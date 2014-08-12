#!/usr/bin/env python

# example python-demo.py

import pygtk
pygtk.require('2.0')
import gtk

class PythonDemo(gtk.Window):

    def hello(self, widget, data=None):
        print "Hello World"
        md = gtk.MessageDialog(self, gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_INFO, gtk.BUTTONS_CLOSE, "Well hello there!")
        md.run()
        md.destroy()

    def delete_event(self, widget, event, data=None):
        print "delete event occurred"
        return False

    def closeapp(self, widget, data=None):
        print "destroy signal occurred"
        quit()

    def __init__(self):
        super(PythonDemo, self).__init__()
        
        self.set_size_request(480, 272)
        self.set_position(gtk.WIN_POS_CENTER)
        self.connect("destroy", gtk.main_quit)

        table = gtk.Table(rows=2,columns=1,homogeneous=True)
        
        helloButton  = gtk.Button("Hello World")
        helloButton.connect("clicked", self.hello, None)
        closeButton = gtk.Button("Quit")
        closeButton.connect_object("clicked", self.closeapp, self.window)
        
        table.attach(helloButton, 0, 1, 0, 1)
        table.attach(closeButton, 0, 1, 1, 2)
        self.add(table)
        self.show_all()

    def main(self):
        gtk.main()

if __name__ == "__main__":
    demo = PythonDemo() 
    demo.main()



