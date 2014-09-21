" File: pythonhelper.vim
" Author: Michal Vitecek <fuf-at-mageo-dot-cz>
" Version: 0.81
" Last Modified: Oct 24, 2002
"
" Modified by Marius Gedminas <mgedmin@b4net.lt>
"
" Overview
" --------
" Vim script to help moving around in larger Python source files. It displays
" current class, method or function the cursor is placed in on the status
" line for every python file. It's more clever than Yegappan Lakshmanan's
" taglist.vim because it takes into account indetation and comments to
" determine what tag the cursor is placed in.
"
" Requirements
" ------------
" This script needs only VIM compiled with Python interpreter. It doesn't rely
" on exuberant ctags utility. You can determine whether your VIM has Python
" support by issuing command :ver and looking for +python in the list of
" features.
"
" Note: The script displays current tag on the status line only in NORMAL
" mode. This is because CursorHold event is fired up only in this mode.
" However if you badly need to know what tag you are in even in INSERT or
" VISUAL mode, contact me on the above specified email address and I'll send
" you a patch that enables firing up CursorHold event in those modes as well.
"
" Installation
" ------------
" 1. Make sure your Vim has python feature on (+python). If not, you will need
"    to recompile it with --with-pythoninterp option to the configure script
" 2. Copy script pythonhelper.vim to the $HOME/.vim/plugin directory
" 3. Run Vim and open any python file.
" 
" Marius Gedminas <marius@gedmin.as>:
" 4. change 'statusline' to include
"      %{TagInStatusLine()}
" 
if has("python")
python << EOS

# import of required modules {{{
import vim
import time
import sys
import re
# }}}


# global dictionaries of tags and their line numbers, keys are buffer numbers {{{
TAGS = {}
TAGLINENUMBERS = {}
BUFFERTICKS = {}
# }}}


# class PythonTag() {{{
class PythonTag:
    # DOC {{{
    """A simple storage class representing a python tag.
    """
    # }}}


    # STATIC VARIABLES {{{
    
    # tag type IDs {{{
    TAGTYPE_CLASS       = 0
    TAGTYPE_METHOD      = 1
    TAGTYPE_FUNCTION    = 2
    # }}}

    # tag type names {{{
    typeName = {
        TAGTYPE_CLASS    : "class",
        TAGTYPE_METHOD   : "method",
        TAGTYPE_FUNCTION : "function",
    }
    # }}}

    # }}}


    # METHODS {{{
    
    def __init__(self, type, name, fullName, lineNumber, indentLevel, parentTag):
        # DOC {{{
        """Initializes instances of class PythonTag().

        Parameters
            
            type -- tag type

            name -- short tag name

            fullName -- full tag name (in dotted notation)

            lineNumber -- line number on which the tag starts

            indentLevel -- indentation level of the tag
        """
        # }}}

        # CODE {{{
        self.type = type
        self.name = name
        self.fullName = fullName
        self.lineNumber = lineNumber
        self.indentLevel = indentLevel
        self.parentTag = parentTag
        # }}}


    def __str__(self):
        # DOC {{{
        """Returns a string representation of the tag.
        """
        # }}}

        # CODE {{{
        return "%s (%s) [%s, %u, %u]" % (self.name, PythonTag.typeName[self.type],
                                         self.fullName, self.lineNumber, self.indentLevel,)
        # }}}

    __repr__ = __str__


    # }}}
# }}}
        

# class SimplePythonTagsParser() {{{ 
class SimplePythonTagsParser:
    # DOC {{{
    """Provides a simple python tag parser. Returns list of PythonTag()
    instances.
    """
    # }}}


    # STATIC VARIABLES {{{

    # how many chars a single tab represents (visually)
    TABSIZE                     = 8
    
    # regexp used to get indentation and strip comments
    commentsIndentStripRE       = re.compile('([ \t]*)([^\n#]*).*')
    # regexp used to get class name
    classRE                     = re.compile('class[ \t]+([a-zA-Z0-9_]+)[ \t]*([(:].*|$)')
    # regexp used to get method or function name
    methodRE                    = re.compile('def[ \t]+([^(]+).*')

    # }}}


    # METHODS {{{
    
    def __init__(self, source):
        # DOC {{{
        """Initializes the instance of class SimplePythonTagsParser().

        Parameters

            source -- source for which the tags will be generated. It must
                provide callable method readline (i.e. as file objects do).
        """
        # }}}

        # CODE {{{
        # make sure source has readline() method {{{
        if (not(hasattr(source, 'readline') and
                callable(source.readline))):
            raise AttributeError("Source must have callable readline method.")
        # }}}
                
        # remember what the source is
        self.source = source
        # }}}

    
    def getTags(self):
        # DOC {{{
        """Determines all the tags for the buffer. Returns tuple in format
        (tagLineNumbers, tags,).
        """
        # }}}

        # CODE {{{
        tagLineNumbers = []
        tags = {}

        # list (stack) of all currently active tags
        tagsStack = []
        
        lineNumber = 0
        while 1:
            # get next line
            line = self.source.readline()

            # finish if this is the end of the source {{{
            if (line == ''):
                break
            # }}}

            lineNumber += 1
            lineMatch = self.commentsIndentStripRE.match(line)
            lineContents = lineMatch.group(2)
            # class tag {{{
            tagMatch = self.classRE.match(lineContents)
            if (tagMatch):
                currentTag = self.getPythonTag(tagsStack, lineNumber, lineMatch.group(1),
                                               tagMatch.group(1), self.tagClassTypeDecidingMethod)
                tagLineNumbers.append(lineNumber)
                tags[lineNumber] = currentTag
            # }}}
            # function/method/none tag {{{
            else:
                tagMatch = self.methodRE.match(lineContents)
                if (tagMatch):
                    currentTag = self.getPythonTag(tagsStack, lineNumber, lineMatch.group(1),
                                                   tagMatch.group(1), self.tagFunctionTypeDecidingMethod)
                    tagLineNumbers.append(lineNumber)
                    tags[lineNumber] = currentTag
            # }}}

        # return the tags data for the source
        return (tagLineNumbers, tags,)
        # }}}


    def getPreviousTag(self, tagsStack):
        # DOC {{{
        """Returns the previous tag (instance of PythonTag()) from the
        specified tag list if possible. If not, returns None.

        Parameters

            tagsStack -- list (stack) of currently active PythonTag() instances
        """
        # }}}

        # CODE {{{
        if (len(tagsStack)):
            previousTag = tagsStack[-1]
        else:
            previousTag = None
         
        # return the tag
        return previousTag
        # }}}


    def computeIndentLevel(self, indentChars):
        # DOC {{{
        """Computes indent level from the specified string.

        Parameters

            indentChars -- white space before any other character on line
        """
        # }}}

        # CODE {{{
        indentLevel = 0
        for char in indentChars:
            if (char == '\t'):
                indentLevel += self.TABSIZE
            else:
                indentLevel += 1

        return indentLevel
        # }}}


    def getPythonTag(self, tagsStack, lineNumber, indentChars, tagName, tagTypeDecidingMethod):
        # DOC {{{
        """Returns instance of PythonTag() based on the specified data.

        Parameters

            tagsStack -- list (stack) of tags currently active. Note: Modified
                in this method!

            lineNumber -- current line number

            indentChars -- characters making up the indentation level of the
                current tag

            tagName -- short name of the current tag

            tagTypeDecidingMethod -- reference to method that is called to
                determine type of the current tag
        """
        # }}}

        # CODE {{{
        indentLevel = self.computeIndentLevel(indentChars)
        previousTag = self.getPreviousTag(tagsStack)
        # code for enclosed tag {{{
        while (previousTag):
            if (previousTag.indentLevel >= indentLevel):
                del tagsStack[-1]
            else:
                tagType = tagTypeDecidingMethod(previousTag.type)
                tag = PythonTag(tagType, tagName, "%s.%s" % (previousTag.fullName, tagName,), lineNumber, indentLevel, previousTag)
                tagsStack.append(tag)
                return tag
            previousTag = self.getPreviousTag(tagsStack)
        # }}}
        # code for tag in top indent level {{{
        else:
            tagType = tagTypeDecidingMethod(None)
            tag = PythonTag(tagType, tagName, tagName, lineNumber, indentLevel, None)
            tagsStack.append(tag)
            return tag
        # }}}
        # }}}


    def tagClassTypeDecidingMethod(self, previousTagsType):
        # DOC {{{
        """Returns tag type of the current tag based on its previous tag (super
        tag) for classes.
        """
        # }}}

        # CODE {{{
        return PythonTag.TAGTYPE_CLASS
        # }}}


    def tagFunctionTypeDecidingMethod(self, previousTagsType):
        # DOC {{{
        """Returns tag type of the current tag based on its previous tag (super
        tag) for functions/methods.
        """
        # }}}

        # CODE {{{
        if (previousTagsType == PythonTag.TAGTYPE_CLASS):
            return PythonTag.TAGTYPE_METHOD
        else:
            return PythonTag.TAGTYPE_FUNCTION
        # }}}


    # }}}
# }}}


# class VimReadlineBuffer() {{{
class VimReadlineBuffer:
    # DOC {{{
    """A simple wrapper class around vim's buffer that provides readline
    method.
    """
    # }}}


    # METHODS {{{

    def __init__(self, vimBuffer):
        # DOC {{{
        """Initializes the instance of class VimReadlineBuffer().

        Parameters

            vimBuffer -- VIM's buffer
        """
        # }}}

        # CODE {{{
        self.vimBuffer = vimBuffer
        self.currentLine = -1
        self.bufferLines = len(vimBuffer)
        # }}}


    def readline(self):
        # DOC {{{
        """Returns next line from the buffer. If all the buffer has been read,
        returns empty string.
        """
        # }}}

        # CODE {{{
        self.currentLine += 1

        # notify end of file if we reached beyond the last line {{{
        if (self.currentLine == self.bufferLines):
            return ''
        # }}}

        # return the line with added newline (vim stores the lines without newline)
        return "%s\n" % (self.vimBuffer[self.currentLine],)
        # }}}
    
    # }}}
# }}}


def getNearestLineIndex(row, tagLineNumbers):
    # DOC {{{
    """Returns index of line in tagLineNumbers list that is nearest to the
    current cursor row.

    Parameters

	row -- current cursor row

	tagLineNumbers -- list of tags' line numbers (ie. their position)
    """
    # }}}

    # CODE {{{
    nearestLineNumber = -1
    nearestLineIndex = -1
    i = 0
    for lineNumber in tagLineNumbers:
	# if the current line is nearer the current cursor position, take it {{{
	if (nearestLineNumber < lineNumber <= row):
	    nearestLineNumber = lineNumber
	    nearestLineIndex = i
	# }}}
	# if we've got past the current cursor position, let's end the search {{{
	if (lineNumber >= row):
	    break
	# }}}
	i += 1
    return nearestLineIndex
    # }}}


def getTags(bufferNumber, changedTick):
    # DOC {{{
    """Reads the tags for the specified buffer number. Returns tuple
    (taglinenumber[buffer], tags[buffer],).

    Parameters

	bufferNumber -- number of the current buffer

	changedTick -- ever increasing number used to tell if the buffer has
	    been modified since the last time
    """
    # }}}

    # CODE {{{
    global	TAGLINENUMBERS, TAGS, BUFFERTICKS

    # return immediately if there's no need to update the tags {{{
    if ((BUFFERTICKS.has_key(bufferNumber)) and (BUFFERTICKS[bufferNumber] == changedTick)):
	return (TAGLINENUMBERS[bufferNumber], TAGS[bufferNumber],)
    # }}}

    # get the tags {{{
    simpleTagsParser = SimplePythonTagsParser(VimReadlineBuffer(vim.current.buffer))
    tagLineNumbers, tags = simpleTagsParser.getTags()
    # }}}

    # update the global variables {{{
    TAGS[bufferNumber] = tags
    TAGLINENUMBERS[bufferNumber] = tagLineNumbers
    BUFFERTICKS[bufferNumber] = changedTick
    # }}}

    # return the tags data
    return (tagLineNumbers, tags,)
    # }}}


def findTag(bufferNumber, changedTick):
    # DOC {{{
    """Tries to find the best tag for the current cursor position.

    Parameters

	bufferNumber -- number of the current buffer

	changedTick -- ever increasing number used to tell if the buffer has
	    been modified since the last time
    """
    # }}}

    # CODE {{{
    try:
	# get the tags data for the current buffer {{{
	tagLineNumbers, tags = getTags(bufferNumber, changedTick)
        # }}}

	# link to vim internal data {{{
	currentBuffer = vim.current.buffer
	currentWindow = vim.current.window
	row, col = currentWindow.cursor
	# }}}

	# get the index of the nearest line
	nearestLineIndex = getNearestLineIndex(row, tagLineNumbers)
	# if any line was found, try to find if the tag is appropriate {{{
	# (ie. the cursor can be below the last tag but on a code that has nothing
	# to do with the tag, because it's indented differently, in such case no
	# appropriate tag has been found.)
	if (nearestLineIndex > -1):
	    nearestLineNumber = tagLineNumbers[nearestLineIndex]
            tagInfo = tags[nearestLineNumber]
	    # walk through all the lines in range (nearestTagLine, cursorRow) {{{
	    for i in xrange(nearestLineNumber + 1, row):
		line = currentBuffer[i]
		# count the indentation of the line, if it's lower that the tag's, the found tag is wrong {{{
		if (len(line)):
                    # compute the indentation of the line {{{
		    lineStart = 0
		    j = 0
		    while ((j < len(line)) and (line[j].isspace())):
			if (line[j] == '\t'):
			    lineStart += SimplePythonTagsParser.TABSIZE
			else:
			    lineStart += 1
			j += 1
                    # if the line contains only spaces, it doesn't count {{{
                    if (j == len(line)):
                        continue
                    # }}}
                    # if the next character is # (python comment), this line doesn't count {{{
                    if (line[j] == '#'):
                        continue
                    # }}}
                    # }}}
                    # if the line's indentation starts before or at the nearest tag's one, the tag is wrong {{{
		    while tagInfo is not None and lineStart <= tagInfo.indentLevel:
                        tagInfo = tagInfo.parentTag
                    # }}}
		# }}}
	    # }}}
	else:
	    tagInfo = None
	# }}}
	 
	# describe the cursor position (what tag it's in) {{{
	tagDescription = ""
	if tagInfo is not None:
	    ## tagDescription = "[in %s (%s)]" % (tagInfo.fullName, PythonTag.typeName[tagInfo.type],)
	    tagDescription = "[%s]" % (tagInfo.fullName, )
	# }}}

	# update the variable for the status line so it will be updated next time
	vim.command("let w:PHStatusLine=\"%s\"" % (tagDescription,))
    except:
        # spit out debugging information {{{
	ec, ei, tb = sys.exc_info()
	while (tb != None):
	    if (tb.tb_next == None):
		break
	    tb = tb.tb_next
	print "ERROR: %s %s %s:%u" % (ec.__name__, ei, tb.tb_frame.f_code.co_filename, tb.tb_lineno,)
	time.sleep(0.5)
        # }}}
    # }}}


def deleteTags(bufferNumber):
    # DOC {{{
    """Removes tags data for the specified buffer number.

    Parameters

        bufferNumber -- number of the buffer
    """
    # }}}

    # CODE {{{
    global      TAGS, TAGLINENUMBERS, BUFFERTICKS
    
    try:
        del TAGS[bufferNumber]
        del TAGLINENUMBERS[bufferNumber]
        del BUFFERTICKS[bufferNumber]
    except:
        pass
    # }}}


EOS

" VIM functions {{{

function! PHCursorHold()
    " only python is supported {{{
    if (!exists('b:current_syntax') || (b:current_syntax != 'python'))
	let w:PHStatusLine = ''
	return
    endif
    " }}}
    
    " call python function findTag() with the current buffer number and changed ticks
    execute 'python findTag(' . expand("<abuf>") . ', ' . b:changedtick . ')'
endfunction


function! PHBufferDelete()
    " set PHStatusLine for this window to empty string
    let w:PHStatusLine = ""
    
    " call python function deleteTags() with the cur
    execute 'python deleteTags(' . expand("<abuf>") . ')'
endfunction


function! TagInStatusLine()
    " return value of w:PHStatusLine in case it's set
    if (exists("w:PHStatusLine"))
        return w:PHStatusLine
    " otherwise just return empty string
    else
        return ""
    endif
endfunction

" }}}


" event binding, vim customizing {{{

" autocommands binding
if v:version >= 700
    autocmd CursorMoved * call PHCursorHold()
else
    autocmd CursorHold * call PHCursorHold()
endif
autocmd BufDelete * silent call PHBufferDelete()

"" " time that determines after how long time of no activity the CursorHold event
"" " is fired up
"" set updatetime=1000
"" 
"" " color of the current tag in the status line (bold cyan on black)
"" highlight User1 gui=bold guifg=cyan guibg=black
"" " color of the modified flag in the status line (bold black on red)
"" highlight User2 gui=bold guifg=black guibg=red
"" " the status line will be displayed for every window
"" set laststatus=2
"" " set the status line to display some useful information
"" set stl=%-f%r\ %2*%m%*\ \ \ \ %1*%{TagInStatusLine()}%*%=[%l:%c]\ \ \ \ [buf\ %n]

" }}}

" vim:foldmethod=marker
endif " has("python")
