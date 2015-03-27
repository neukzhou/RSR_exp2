addpath('./mat/err');

dim = 15;
spars_interval = 30;

%data = zeros(spars_interval,dim);


data = [];

for i = 1:dim
    str = ['load err_dim' num2str(i), '.mat err'];
    eval(str);
    for j = 1:5
        data = [data;median(err{j}')];
    end
end

data = data';

figure;
plot(data);

dt = data;
dt(find(dt>0.02))=0.02;
a = (0.02-dt)/0.02;
a = flipud(a);

figure;
colormap(gray);
imagesc([1 dim+1],[spars_interval/2 0.5],a);
set(gca,'YDir','normal')

figure;
plot(dt);