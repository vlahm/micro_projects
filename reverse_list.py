
file_to_reverse = '/home/mike/git/streampulse/server_copy/sp/templates/l.md'

with open(file_to_reverse, 'r') as f:
    text = f.read()

e = text.split('###')
e = reversed(e)
e = '###'.join(e)

output_file = '/home/mike/git/streampulse/server_copy/sp/templates/logbook.md'

with open(output_file, 'w') as o:
    o.write(e)
