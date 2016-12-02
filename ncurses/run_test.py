import curses

if __name__ == '__main__':
    screen = curses.initscr()
    try:
        try:
            curses.cbreak()
            pad = curses.newpad(10, 10)
            size = screen.getmaxyx()
            pad.refresh(0, 0, 0, 0, size[0] - 1, size[1] - 1)
        finally:
            curses.nocbreak()
            curses.endwin()
    except Exception as e:
        print("Testing ncurses excepted, probably redirected tty, ignoring:\n%s" % e)
