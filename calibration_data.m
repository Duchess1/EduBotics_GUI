u = udp('192.168.4.1', 2233, 'LocalPort', 2233);
fopen(u);

fwrite(u, uint8(5));
pause(1)
fwrite(u, uint8(7)); 

while (u.BytesAvailable == 0)
    
end

res = fgetl(u);
delimiter = strfind(res,':')
readings = res(delimiter+1:end)
readings = str2num(readings)
fwrite(u, "OK" + newline); 

data = zeros(readings,3); 
for i = 1:readings
    res = fgetl(u);
    delimiters = strfind(res,',');
    reading_num = str2double(res(1:delimiters(1)-1));
    timestamp = str2double(res(delimiters(1)+1:delimiters(2)-1));
    value = str2double(res(delimiters(2)+1:end))/2;
    
    data(i,1) = reading_num;
    data(i,2) = timestamp;
    data(i,3) = value;
    
    disp(i);
end

plot(data(:,3))

excel_data = table(data(:,1), data(:,2), data(:,3))
excel_data.Properties.VariableNames = {'Sample', 'Timestamp', 'Value'}
text
writetable(excel_data,'data.xls')