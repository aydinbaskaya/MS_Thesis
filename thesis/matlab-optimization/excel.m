NET.addAssembly('microsoft.office.interop.excel');
app = Microsoft.Office.Interop.Excel.ApplicationClass;
book =  app.Workbooks.Open('C:\Users\Aydin\Desktop\yeni kod\ref_table.xls');
sheet = Microsoft.Office.Interop.Excel.Worksheet(book.Worksheets.Item(1)); 
range = sheet.UsedRange;
arr = range.Value;
data = cell(arr,'ConvertTypes',{'all'});
%cellfun(@disp,data(:,1))
ref_table=ones(10,5);
for i=2:11
    for j=1:5
        ref_table(i-1,j)=data{i,j} ;
    end
end
  