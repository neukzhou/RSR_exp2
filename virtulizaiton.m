dim = 15;
spars_interval = 30;

data = zeros(spars_interval,dim);

for i = 1:dim
    str = ['load err_dim' num2str(i), ' errDim'];
    eval(str);
    tmp = mean(errDim');
    data(:,i) = tmp';
end

figure;
plot(0.5:0.5:15,data)
hold on;
line([0 spars_interval/2],[0.2 0.2],'LineStyle','-.', 'Color', 'r');
hold off;

dt = data;

dt(find(dt>0.10))=0.10;
a = (0.10-dt)/0.10;
a = flipud(a);

figure;
colormap(gray);
imagesc([1 dim],[spars_interval/2 0.5],a);
set(gca,'YDir','normal')

figure;
plot(dt);