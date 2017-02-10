function [New_lan_x New_lan_y IMG_rotate]=rotate_crop(IMG,pos,axe_x,axe_y,mode);

% if mode ==1;
%     if (size(IMG, 1)~=100  || size(IMG, 2)~= 100)
%         IMG2 = imresize(IMG, [100, 100], 'bilinear');
%     else
%         IMG2=IMG;
%     end
% else
%     IMG2=IMG;
% end
%IMG=IMG;
% figure(11),imshow(IMG);
% hold on;
% plot(axe_x,axe_y,'-','LineWidth',2);
% plot(axe_x,axe_y,'g+','LineWidth',2);

[m n kkk]=size(IMG);
tg_a=diff(pos(2,:))/diff(pos(1,:));
angle=tg_a*(180/pi);
tg_a = -angle * (pi/180);
IMG_rotate = imrotate(IMG, angle);
% figure(7),imshow(IMG3);
[m1 n1 y1]=size(IMG_rotate);
Rx=axe_x(:);Ry=axe_y(:);
% figure(3),imshow(IMG); 
% hold on;
% plot(Rx,Ry,'g+','LineWidth',2);
% pause;
Ex = (n1-n)/2;
Ey = (m1-m)/2;
Cx=n/2;Cy=m/2;
New_lan_x= (Cx+(Rx-Cx)*cos(tg_a)-(Ry-Cy)*sin(tg_a))+Ex;
New_lan_y= (Cy+(Rx-Cx)*sin(tg_a)+(Ry-Cy)*cos(tg_a))+Ey;
% figure(12),imshow(IMG_rotate);
% hold on;
% plot(New_lan_x,New_lan_y,'-','LineWidth',2);
% plot(New_lan_x,New_lan_y,'g+','LineWidth',2);