from xml.dom.minidom import Document

# Create the minidom document
doc = Document()
# Print our newly created XML
f = open("D:/Research/output.xml", "w")
try:
    f.write(doc.toprettyxml(indent="  "))
finally:
    f.close()
