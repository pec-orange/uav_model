function cost = Real_cvadro_model1(Kp,Kd,Ku)
clc
%�������������� ���������
a = 0.36;%����� ������������� � ������
k = 1.4851*10^-4;% k - ��������� ����������
h = 0.07;%������ ������������
b = h/2;
L = 485/2/1000; %���������� �� ����� ������������� �� �����
m = 0.3;%����� �������������
g = 9.81;%��������� ���������� �������
Ix = 1/12*m*(3*L^3+h^2);%������ �������
Iz=Ix;%������ �������
Iy=m*L^2/2;%������ ������� 
Irot =0;%������ ������� ������
Sx = a*h; Sz=a*h;Sy =a*a;%������� ������������ �������������
t =10;%����� �������������
cd =0.1;%���������������� �����������
md =0.004;%���������������� �����������
po=1.2;%��������� �������
n=105/2;
% ����������� �������� �������� �������� ������ ��� ��������� �� �����
W1 = 128.5; W2 = 128.5; W3 = 128.5; W4 = 128.5; 
%��������� ������� �� ��������� � �������������� � ��������� ��
Vbx(1) =0; Vby(1) =0;Vbz(1) =0; Vx(1)=0; Vy(1)=0; Vz(1)=0;
%��������� ������� �� ������� ��������� � �������������� � ��������� ��
wbx(1)=0;wby(1)=0;wbz(1)=0;wx(1)=0;wy(1)=0;wz(1)=0;
%��������� ������� �� ����� ����������
psi(1)=45;theta(1)=0;gamma(1)=0;
%��������� ������� �� �����������
x(1)=0;y(1)=0;z(1)=0;
%��������� ��� ��� ����������
sigma_need = [0,0,0];% �������� ���� ����������
sigma_integral =[0,0,0];
%�������� ������� ������� � ���� ������
I =[Ix,Iy,Iz];
dt =0.1;
%��������� ������� ����������� �������
cost(1)=0;
for i=1:t/dt
    %%�������� ���������
    %��� ��� �
    agx = -g*sind(theta(i)); %��������� ���� ������� �� ��� �
    akx = -2*(wby(i)*Vbz(i)-wbz(i)*Vby(i));% ����������� ��������� ����� ��� �
    aadx = -sign(Vbx(i))*cd*po*Vbx(i)^2/2/m*Sx;%���������,��������� ���������������� �����
    axb = agx+akx+aadx;%��������� ��������� ����� ��� �
   %��� ��� � 
    agy = -g*cosd(theta(i))*cosd(gamma(i));%��������� ���� ������� �� ��� �
    aky = -2*(wbz(i)*Vbx(i)-wbx(i)*Vbz(i));%����������� ��������� ����� �
    aady = -sign(Vby(i))*cd*po*Vby(i)^2/2/m*Sy;% ���������, ��������� ���������������� ����� �� �
    aty = k*(W1^2+W2^2+W3^2+W4^2);%��������� �� ���� ����������
    ayb = agy+aky+aady+aty;
    %��� ��� z
    agz = g*cosd(theta(i))*sind(gamma(i));%��������� ���� ������� �� ��� z
    akz = -2*(wbx(i)*Vby(i)-wby(i)*Vbx(i));%����������� ��������� ����� ��� z
    aadz = -sign(Vbz(i))*cd*po*Vbz(i)^2/2/m*Sz;%���������, ��������� ���������������� ����� �� ��� z
    azb = agz+akz+aadz;
    %%������� ���������
    %�� ��� �
    dwxgyr = wby(i)*wbz(i)*((Iy-Iz)/Ix); %�� ������������ �������� �������������
    dwxaer = md*po*Vbx(i)^2/2/m*Sx*n;%�� ����������������� �������
    dwxeng = (k*(W2^2-W1^2)-k*(W4^2-W3^2))*L/Ix;%�� �������� ����������
    dwxrot = Irot/Ix*(W2+W1-W3-W4);%�� ������
    dwbx =dwxgyr+dwxaer+dwxeng+dwxrot;
    %�� ��� �
    dwygyr = wbx(i)*wbz(i)*((Iz-Ix)/Iy);%�� ������������ �������� �������������
    dwyaer = md*po*Vby(i)^2/2/m*Sy*n;%�� ����������������� �������
    dwyeng =(-k*(W1^2+W3^2)+k*(W2^2+W4^2))*b/Iy;%�� �������� ����������
    dwby = dwygyr+dwyaer+dwyeng;
    %�� ��� z
    dwzgyr = wbx(i)*wby(i)*((Ix-Iy)/Iz);%�� ������������ �������� �������������
    dwzaer = md*po*Vbz(i)^2/2/m*Sz*n;%�� ����������������� �������
    dwzeng = (k*(W4^2-W1^2)-k*(W2^2-W3^2))*L/Iz;%�� �������� ����������
    dwzrot = Irot/Iz*wbx(i)*(W3+W4-W2-W1);%�� ������
    dwbz = dwzgyr+dwzaer+dwzeng+dwzrot;
    %���������� �������� � ������ ��������� � ��������� ��
    Vbx(i+1) = Vbx(i)+axb*dt; Vby(i+1)= Vby(i)+ayb*dt;Vbz(i+1)=Vbz(i)+azb*dt;
    wbx(i+1)= wbx(i)+dwbx*dt; wby(i+1)=wby(i)+dwby*dt; wbz(i+1)=wbz(i)+dwbz*dt;
    %�������� ��������� � ���
    dVx = axb*cosd(psi(i))*cosd(theta(i))+ayb*(-cosd(psi(i))*sind(theta(i))*cosd(gamma(i))+sind(psi(i))*sind(gamma(i)))+azb*(cosd(psi(i))*sind(theta(i))*sind(gamma(i))+sind(psi(i))+sind(psi(i))*cosd(gamma(i)));
    dVy = axb*sind(theta(i))+ayb*cosd(theta(i))*cosd(gamma(i))-azb*cosd(theta(i))*sind(gamma(i));
    dVz = -axb*sind(psi(i))*cosd(theta(i))+ayb*(cosd(psi(i))*sind(gamma(i))+sind(psi(i))*sind(theta(i))*cosd(gamma(i)))+azb*(cosd(psi(i))*cosd(gamma(i))+sind(psi(i))*sind(theta(i))*sind(gamma(i)));
    dwx = dwbx*cosd(psi(i))*cosd(theta(i))+dwby*(-cosd(psi(i))*sind(theta(i))*cosd(gamma(i))+sind(psi(i))*sind(gamma(i)))+dwbz*(cosd(psi(i))*sind(theta(i))*sind(gamma(i))+sind(psi(i))+sind(psi(i))*cosd(gamma(i)));
    dwy = dwbx*sind(theta(i))+dwby*cosd(theta(i))*cosd(gamma(i))-dwbz*cosd(theta(i))*sind(gamma(i));
    dwz = -dwbx*sind(psi(i))*cosd(theta(i))+dwby*(cosd(psi(i))*sind(gamma(i))+sind(psi(i))*sind(theta(i))*cosd(gamma(i)))+dwbz*(cosd(psi(i))*cosd(gamma(i))+sind(psi(i))*sind(theta(i))*sind(gamma(i)));
    %���������� ������� ��������� � ����� �����,����� � �������
    dpsi = (wby(i+1)*cosd(gamma(i))-wbz(i+1)*sind(gamma(i)))/cosd(theta(i));
    dtheta= wbz(i+1)*cosd(gamma(i))+wby(i+1)*sind(gamma(i));
    dgamma= wbx(i+1)-(wby(i+1)*cosd(gamma(i))-wbz(i+1)*sind(gamma(i)))*tand(theta(i));
    psi(i+1) = psi(i)+dpsi*dt; theta(i+1) =theta(i)+dtheta*dt;gamma(i+1) =gamma(i)+dgamma*dt;
    %���������� ��������� � ��������� ������������� � ���
    Vx(i+1)= Vx(i)+dVx*dt;Vy(i+1)= Vy(i)+dVy*dt;Vz(i+1)= Vz(i)+dVz*dt;
    x(i+1)= x(i)+Vx(i+1)*dt;  y(i+1)= y(i)+Vy(i+1)*dt;  z(i+1)= z(i)+Vz(i+1)*dt;
    %�������� �� ����
    sigma = [theta(i+1),gamma(i+1),psi(i+1)];
    sigmadot =[dtheta,dgamma,dpsi];
    sigma_integral = sigma_integral+sigma*dt;
    %��� ���������
    [W1,W2,W3,W4] = controller(sigma_need,sigma,sigmadot,m,g,k,0.7426*10^-4,I,L,sigma_integral,Kp,Kd,Ku);
    OMEGA(:,i)=[W1,W2,W3,W4];
     % ������� ��������� (������) ��� ������������� ������� �������������
    % ����������
    cost(i+1) =cost(i)+ 1/(t/dt - 1) * sum((sigma_need - sigma).^2) * dt;
        if isnan(cost(i+1))
            cost = NaN;
            return
        end
    end
    cost=cost(i+1);
end



