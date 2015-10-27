# From http://zetcode.com/gui/pyqt4/firstprograms/

import sys
from PyQt5 import QtWidgets


def main():
    
    app = QtWidgets.QApplication(sys.argv)

    w = QtWidgets.QWidget()
    w.resize(250, 150)
    w.move(300, 300)
    w.setWindowTitle('Simple Test')
    w.show()
    
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
