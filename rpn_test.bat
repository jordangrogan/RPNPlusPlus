@echo off
echo File 1 > output.txt
ruby rpn.rb ScriptTests\File1.rpn >> output.txt
echo File 2 >> output.txt
ruby rpn.rb ScriptTests\File2.rpn >> output.txt
echo File 3 >> output.txt
ruby rpn.rb ScriptTests\File3.rpn >> output.txt
echo Bad 1 >> output.txt
ruby rpn.rb ScriptTests\Bad.rpn >> output.txt
echo Bad 2 >> output.txt
ruby rpn.rb ScriptTests\Bad2.rpn >> output.txt
echo Bad 3 >> output.txt
ruby rpn.rb ScriptTests\Bad3.rpn >> output.txt
echo Bad 4 >> output.txt
ruby rpn.rb ScriptTests\Bad4.rpn >> output.txt
fc output.txt ScriptTests\golden.txt