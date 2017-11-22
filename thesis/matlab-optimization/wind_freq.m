
% .m file for calculate the wind speed distribution for a given wind-speed data file (.csv)

% speed category initialization
speed_0=0;
speed_1=0;
speed_2=0;
speed_3=0;
speed_4=0;
speed_5=0;
speed_6=0;
speed_7=0;
speed_8=0;
speed_9=0;
speed_10=0;
speed_11=0;
speed_12=0;

fileID ='KORU_RES.csv';         
A=csvread(fileID,1,1);          % read wind speed data file
plot(A(:,1))
array=A(:,2);                   % plot raw data
n=size(array,1);

% Wind speed classification according to speed/data classification part : 

for i=1:1:n
    
     if array(i)<1
        speed_0=speed_0+1 ;         %wind speeds below 1 m/s are included in 0 m/s speed
     end

     if (array(i)>=1)&(array(i)<2)
        speed_1=speed_1+1 ;
     end

      if (array(i)>=2)&(array(i)<3)
        speed_2=speed_2+1 ;
      end
     
    if (array(i)>=3)&(array(i)<4)
        speed_3=speed_3+1 ;
    end

    if (array(i)>=4)&(array(i)<5)
        speed_4=speed_4+1 ;
    end

    if (array(i)>=5)&(array(i)<6)
        speed_5=speed_5+1 ;
    end

    if (array(i)>=6)&(array(i)<7)
        speed_6=speed_6+1 ;
    end

    if (array(i)>=7)&(array(i)<8)
        speed_7=speed_7+1 ;
    end

    if (array(i)>=8)&(array(i)<9)
        speed_8=speed_8+1 ;
    end

    if (array(i)>=9)&&(array(i)<10)
        speed_9=speed_9+1 ;
    end

    if (array(i)>=10)&&(array(i)<11)
        speed_10=speed_10+1 ;
    end

    if (array(i)>=11)&&(array(i)<12)
        speed_11=speed_11+1 ;
    end

    if array(i)>=12
        speed_12=speed_12+1 ;           %wind speeds above 12 m/s are included in 12 m/s rated speed
    end

end

% Find wind speed frequencies

freq_0=(speed_0/n)*100;
freq_1=(speed_1/n)*100;
freq_2=(speed_2/n)*100;
freq_3=(speed_3/n)*100;
freq_4=(speed_4/n)*100;
freq_5=(speed_5/n)*100;
freq_6=(speed_6/n)*100;
freq_7=(speed_7/n)*100;
freq_8=(speed_8/n)*100;
freq_9=(speed_9/n)*100;
freq_10=(speed_10/n)*100;
freq_11=(speed_11/n)*100;
freq_12=(speed_12/n)*100;
