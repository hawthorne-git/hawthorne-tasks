require 'spreadsheet'

book = Spreadsheet.open('C:\Users\ht-ruby\Desktop\JoAnn\input\RCERT ARTICLE CREATION VENDOR TEMPLATE Fabric.xlsx', 'rb')

sheet = book.worksheet(0)

sheet[3,3] = 222

book.write 'C:\Users\ht-ruby\Desktop\JoAnn\output\out_1.xls'