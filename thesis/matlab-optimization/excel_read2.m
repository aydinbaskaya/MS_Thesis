function [table]=excel_read2()

% WARNING:this function reads power-speed data with wind velocities

NET.addAssembly('microsoft.office.interop.excel');
app = Microsoft.Office.Interop.Excel.ApplicationClass;
book =  app.Workbooks.Open('C:\Users\Aydin\Desktop\yeni kod\ref_table.xls');
sheet = Microsoft.Office.Interop.Excel.Worksheet(book.Worksheets.Item(1)); 
range = sheet.UsedRange;
arr = range.Value;
data = cell(arr,'ConvertTypes',{'all'});        %data read with names
%cellfun(@disp,data(:,1))
ref_table=ones(9,6);
for i=2:10
    for j=1:6
        ref_table(i-1,j)=data{i,j} ;      %read reference power speed values
    end
end
table=ref_table ;