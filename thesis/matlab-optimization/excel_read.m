function [table]=excel_read

% WARNING:this function reads power-speed data without wind velocities

NET.addAssembly('microsoft.office.interop.excel');
app = Microsoft.Office.Interop.Excel.ApplicationClass;
book =  app.Workbooks.Open('C:\Users\Aydin\Desktop\yeni kod\ref_table.xls');
sheet = Microsoft.Office.Interop.Excel.Worksheet(book.Worksheets.Item(1)); 
range = sheet.UsedRange;
arr = range.Value;
data = cell(arr,'ConvertTypes',{'all'});
%cellfun(@disp,data(:,1))
ref_table=ones(10,5);
for i=2:10
    for j=2:6
        ref_table(i-1,j-1)=data{i,j} ;      %read reference wind speed values
    end
end
ref_table(10,:)=[] ;                        %delete dummy row of reference table
table=ref_table ;