
clear all

%%%%INPUTS%%%%%%%%%%%%%%%%%
%number of time points
p = 56;

%percent of frequncies in Fourier transform to keep 
b = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%openning file and reading into a matrix

coords = []; 
for j = 1:p
    str = string(j-1); 
    if strlength(str) == 1
        nam = '00' + str;
    else
        nam = '0' + str; %loop over all the file names, taking into account some start w 00 and some with 0
    end
    
    name = 'B6E8_D5_TEST_'+nam+'.csv';


    %read file
    m = readmatrix(name) ;


    m(:,1:2) = -1.*m(:,1:2); %make x and y not negative

    coords = [coords m];

end

%coords is set up like [(x1(t1),y1(t1),z1(t1)), (x1(t2),y1(t2),z1(t2))...;
%                       (x2(t1),y2(t1),z2(t1)), (x2(t2),y2(t2),z2(t2))...;...]
%every row is a different point, every three columns is x, y, and z at each


l = length(coords(1,:)); %how many time points * 3
q = length(coords(:,1));

s = ones(size(coords)); %to save smoothed coords in
for n = 1:q %loop over the nodes (rows)
    x = ones(1, p);
    y = ones(1, p);
    z = ones(1, p);
    for xs = 1:3:(l-2)
        x(((xs-1)/3)+1) = coords(n, xs); %make vector of all the x values at each time point, do the same for y and z
    end
    for ys = 2:3:(l-1)
       y(((ys-2)/3)+1) = coords(n, ys);
    end
    for zs = 3:3:l
        z(zs/3) = coords(n, zs);
    end
    x_til = fft(x); %forier transform on each dimension
    y_til = fft(y);
    z_til = fft(z);

    mat = [x_til; y_til; z_til;]; %matrix of the fourier transforms on each dimension

    matn = ones(size(mat)); %matrix of smoothed x y and z

   
    for pp = 1:3 %loop over x y and z
        fy = ones(1, p); 
        c = ceil((p-1)*b/100);
        for w = 1:p
            if w > c && w <= ((p - c) + 1)
                fy(w) = 0;
            else
                fy(w) = mat(pp, w);
            end
        end
        matn(pp, :) = ifft(fy); 
    end
    
    
    
    for a = 1:3:(l-2)
        s(n, a) = matn(1, (((a-1)/3)+1));
        s(n,a+1) = matn(2, (((a-1)/3)+1));
        s(n,a+2) = matn(3, (((a-1)/3)+1));
    end
    
end






%below is to graph the last nodes smoothed vs original coordinates, right
%now is set to z but you can also run on x or y

t = 1:p;

figure
hold on
plot(t,matn(1,:)) 
plot(t,x, '.')
legend('filtered', 'with noise')
title('A Single Node''s Z Position vs. Time')
xlabel('Time (s)')
ylabel('Z Position')
hold off
shg

%to graph complex magnitude of fourier spectrum, see how many modes you
%took
figure
hold on
plot(abs(z_til))
plot(abs(fy))
ylim([0 120])
title("Complex Magnitude of fft Spectrum")
xlabel("Frequency of Mode")
ylabel("Magnitude of Mode")
legend('Original Spectrum', strcat('Take only ', num2str(b), ' percent'))



%this plots displacement over time for a node r
% ds = []; %figure out how to preallocate
% for i = 1:length(s(:,1))
%     x0 = s(i, 1);
%     y0 = s(i, 2);
%     z0 = s(i, 3);
%     disps = []; %figure out how to preallocate
%     for k = 4:3:166 %this is bc I know there's 56 time points (so 56*3 is the amount of coords, then -2 for the last x coord), in the future need to create variable for how many time points there are
%         x = s(i,k);
%         y = s(i,k+1);
%         z = s(i,k+2);
%         disp = sqrt(sum([(x-x0)^2,(y-y0)^2,(z-z0)^2]));
%         disps = [disps disp];
%     end
%     ds = [ds; disps];
% end
% 
% r = 1;
% 
% g = ds(r,:);
% t = 1:(p-1); %one less than the number of time points bc there's number of time points - 1 displacements between points
% 
% figure
% plot(t, g)
% shg

%now save to txt file that can be read by fortran code and converted to a
%vtk file
%fortran doesnt like the long rows like I have it set up so the text file
%is set up like (if first number is node and second is time)
% x(1, 1) y(1,1) z(1,1)
% x(2, 1) y(2,1) z(2,1)
% ...all the nodes at time 1
% x(1, 2) y(1,2) z(1,2)

% csvs = [q, p, 0]; %so that the first like is the number of nodes, number of time points, and 0 for the dimension to be right (for fortran to read)
% for ii = 1:3:(l - 2)
%     csv = ones(q, 3); %for time point 1
%     for jj = 1:q
%         csv(jj,:) = s(jj,ii:(ii+2));
%     end
%     csvs = [csvs; csv];
% end
% 
% 
% writematrix(csvs, 'coordinates.txt')



%below code changes file back into coordinates excel files it was
%originally in


for ii = 1:3:(l - 2)
    xl = ones(q, 3); %for each time point
    na = strcat(num2str(ii-1),'.xlsx'); %so that they are numbered from 0
    for jj = 1:q
        xl(jj,:) = s(jj,ii:(ii+2));
    end
    writematrix(xl, na)
end



% 0.xslx (smoothed mesh nodes coordinates at time frame 1)
% 1.xlsx (smoothed mesh nodes coordinates at time frame 2)
% 50.xlsx (smoothed mesh nodes coordinates at time frame 51)
