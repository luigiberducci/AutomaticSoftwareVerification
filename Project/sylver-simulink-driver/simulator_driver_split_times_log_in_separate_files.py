#! /usr/bin/env python

'''
Sylver Simulator Driver v 1.0
'''

'''
MIT License

Copyright (c) 2016 	Federico Mari <mari@di.uniroma1.it>
					Toni Mancini <tmancini@di.uniroma1.it>
					Annalisa Massini <massini@di.uniroma1.it>
					Igor Melatti <melatti@di.uniroma1.it>
					Enrico Tronci <tronci@di.uniroma1.it>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'''

import re

class Writer:
    """Writes to file"""
    def __init__(self, outputFile):
        self.outputFilename = outputFile
        try:
            self.output_fd = open(self.outputFilename, 'w')
        except IOError:
            print "Problems in creating file " + self.outputFilename
            exit
        print "Writer on " + self.outputFilename + " created."
    def add(self, first, second):
        self.output_fd.write(first + "\t" + second + "\n")
        print self.outputFilename + ": " + first + "\t" + second
    def __del__(self):
        self.output_fd.close()
        print "Writer on " + self.outputFilename + " destroyed."

class Reader:
    """Reads from file, compute and sends to correct writer.
    PRE: each line in inputFile is "Command\tCommand ending time"
    """
    def __init__(self, inputFile):
        self.inputFilename = inputFile
        self.writers = {}
        print "Reader on file " + self.inputFilename + " created."
    def addWriter(self, cmd, writer):
        self.writers[cmd] = writer
    def parse(self):
        p = re.compile('^([SLRIF])([0-9]*)\t([^\n]*)\n$')
        c, prev = 0, 0.0
        with open(self.inputFilename) as f:
            for line in f:
                m = p.match(line)
                assert m, "Line " + line + " not matching required pattern."
                v = m.groups()
                assert len(v) == 3, "Line " + line + " not properly matching required pattern."
                assert v[0] in self.writers.keys(), v[0] + " is not an expected command."
                current = float(v[2])
                self.writers[v[0]].add(v[1], str(current - prev))
                prev = current
                c += 1
        print "Reader on file " + self.inputFilename + " wrote " + str(c) + " rows."
    def __del__(self):
        del self.writers
        print "Reader on file " + self.inputFilename + " destroyed."

def main():
    folder = '.'
    r = Reader(folder + '/times_log.txt')
    cmds = ['S', 'L', 'R', 'I', 'F']
    for cmd in cmds:
        r.addWriter(cmd, Writer(folder + '/times_log.' + cmd + '.txt'))
    r.parse()
    del r
    return

if __name__ == '__main__':
    main()
