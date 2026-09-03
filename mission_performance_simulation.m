
%% AERODYNAMIC DATA
CL0 = 0.4
CL_alpha = 5.7
CL_at_CDmin = 0.15  
CDmin = 0.022  

K = 0.035
Alpha_stall = 15
Sref = 20

%% MASS DATA

g = 9.81 % m/s^2
MaxMass = 2500 % in kg
MFV = 1200 % in l
FD = 800
FM = ((MFV-100)/1000)* FD % in kg
MinMass = MaxMass - FM % in kg


%% PROPULSION DATA

PArea = 1.9
PEfficiency = 0.80

PTo = 400
SFCTo = 0.28 
Pmc = 350*745,69987158 % in Watts
SFCmc = 0.25/(3600*1000)
Pc = 280*745,69987158 % in Watts
SFCc = 0.20/(3600*1000) % in kg/W/s


%% MISSION CONDITIONS

AI = 20000*0.3048 % in m
FI = 1200
FF = 100
rho = 1.225*(1-(0.0065*AI)/288.15)^4.256

%% Task 1 
%% A i
CLrange = ((CDmin/K)+CL_at_CDmin^2)^0.5;

Alpharange = (CLrange-CL0)/CL_alpha;
rho = 1.225*(1-(0.0065*AI)/288.15)^4.256;
CDrange = CDmin + K*(CLrange-CL_at_CDmin)^2;
Mass = MaxMass;
Weight = Mass*g ;
Velocity = ((2*Weight)/(rho*CLrange*Sref))^0.5;
time = 0 ;
range = 0 ;
LMass = [];
LDrag = [];
LTime = [];
Lrange = [];
LAltitude = [];
LFuelRemain = [];
while Mass >= MinMass 
    Drag = 1/2*rho*Velocity^2*Sref*CDrange;
    Power = Drag*Velocity/0.8;
    Fuelmassflow = Power*SFCc*5;
    Mass = Mass - Fuelmassflow;
    Weight = Mass*g;
    rho = (2*Weight)/(CLrange*Sref*Velocity^2);
    Altitude = (288.15/0.0065)*(1-(rho/1.225)^(1/4.256));
    time = time + 5;
    range = Velocity*5 + range ;
    FuelRemain = (((Mass  - MinMass)/800)*1000)+100;
    LMass = [LMass,Mass];
    LDrag = [LDrag,Drag];
    LTime = [LTime,time];
    Lrange = [Lrange,range];
    LAltitude = [LAltitude,Altitude];
    LFuelRemain = [LFuelRemain,FuelRemain];
end
%% plot A i  

subplot(2,2,1)
plot(LTime,LMass);
xlabel('Time (s)');
ylabel('Aircraft Mass (kg/s)');
title('Aircraft Mass vs Time')

subplot(2,2,2)
plot(LTime,LAltitude);
xlabel('Time (s)');
ylabel('Altitude (m)');
title('Altitude vs Time')

subplot(2,2,3)
plot(LTime,Lrange);
xlabel('Time (s)');
ylabel('Range (m)');
title('Range vs Time')

subplot(2,2,4)
plot(LTime,LFuelRemain);
xlabel('Time (s)');
ylabel('Fuel Remaining (l)');
title('Fuel Remaining vs Time')

%% A ii
   
CLrange = ((CDmin/K)+CL_at_CDmin^2)^0.5;

Alpharange = (CLrange-CL0)/CL_alpha;

CDrange = CDmin + K*(CLrange-CL_at_CDmin)^2;
Mass = MaxMass;
Weight = Mass*g ;
Velocity = ((2*Weight)/(rho*CLrange*Sref))^0.5;
rho = 1.225*(1-(0.0065*AI)/288.15)^4.256;
time = 0 ;
range = 0 ;
LMass = [];
LDrag = [];
LTime = [];
Lrange = [];
LVelocity = [];
LFuelRemain = [];
while Mass >= MinMass 
    Drag = 1/2*rho*Velocity^2*Sref*CDrange;
    Power =Drag*Velocity/0.8 ;
    Fuelmassflow = Power*SFCc*5;
    Mass = Mass - Fuelmassflow;
    Weight = Mass*g;
    Velocity = ((2*Weight)/(rho*CLrange*Sref))^0.5;
    time = time + 5;
    range = Velocity*5 + range ;
    FuelRemain = (((Mass  - MinMass)/800)*1000)+100;
    LMass = [LMass,Mass];
    LDrag = [LDrag,Drag];
    LTime = [LTime,time];
    Lrange = [Lrange,range];
    LVelocity = [LVelocity,Velocity];
    LFuelRemain = [LFuelRemain,FuelRemain];
end

%% A II plot 

subplot(2,2,1)
plot(LTime,LMass);
xlabel('Time (s)');
ylabel('Aircraft Mass (kg/s)');
title('Aircraft Mass vs Time')

subplot(2,2,2)
plot(LTime,LVelocity);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity vs Time')

subplot(2,2,3)
plot(LTime,Lrange);
xlabel('Time (s)');
ylabel('Range (m)');
title('Range vs Time')

subplot(2,2,4)
plot(LTime,LFuelRemain);
xlabel('Time (s)');
ylabel('Fuel Remaining (l)');
title('Fuel Remaining vs Time')

%% B 

alpha = linspace(0,15*pi/180,1000);

CLendurance = CL0 + CL_alpha*alpha;
CDendurance = CDmin + K*(CLendurance - ones(1,1000)*CL_at_CDmin).^2;

[valeur_max, index_max] = max((CLendurance.^3/2)./CDendurance);

plot(alpha,(CLendurance.^3/2)./CDendurance)
xlabel('alpha (rad)');
ylabel('CLendurance.^3/2)./CDendurance');

CLenduranceop = CLendurance(index_max)
CDenduranceop = CDendurance(index_max)

%% B i

rho = 1.225*(1-(0.0065*AI)/288.15)^4.256;
Mass = MaxMass;
Weight = Mass*g ;
Velocity = ((2*Weight)/(rho*CLenduranceop*Sref))^0.5;
time = 0 ;
range = 0 ;
LMass = [];
LDrag = [];
LTime = [];
Lrange = [];
LAltitude = [];
LFuelRemain = [];
while Mass >= MinMass 
    Drag = 1/2*rho*Velocity^2*Sref*CDenduranceop;
    Power = Drag*Velocity/0.8;
    Fuelmassflow = Power*SFCc*5;
    Mass = Mass - Fuelmassflow;
    Weight = Mass*g;
    rho = (2*Weight)/(CLenduranceop*Sref*Velocity^2);
    Altitude = (288.15/0.0065)*(1-(rho/1.225)^(1/4.256));
    time = time + 5;
    range = Velocity*5 + range ;
    FuelRemain = (((Mass  - MinMass)/800)*1000)+100;
    LMass = [LMass,Mass];
    LDrag = [LDrag,Drag];
    LTime = [LTime,time];
    Lrange = [Lrange,range];
    LAltitude = [LAltitude,Altitude];
    LFuelRemain = [LFuelRemain,FuelRemain];
end

%% plot B i 
subplot(2,2,1)
plot(LTime,LMass);
xlabel('Time (s)');
ylabel('Aircraft Mass (kg/s)');
title('Aircraft Mass vs Time')

subplot(2,2,2)
plot(LTime,LAltitude);
xlabel('Time (s)');
ylabel('Altitude (m)');
title('Altitude vs Time')

subplot(2,2,3)
plot(LTime,Lrange);
xlabel('Time (s)');
ylabel('Range (m)');
title('Range vs Time')

subplot(2,2,4)
plot(LTime,LFuelRemain);
xlabel('Time (s)');
ylabel('Fuel Remaining (l)');
title('Fuel Remaining vs Time')
%% B ii

Mass = MaxMass;
Weight = Mass*g ;
Velocity = ((2*Weight)/(rho*CLenduranceop*Sref))^0.5;
rho = 1.225*(1-(0.0065*AI)/288.15)^4.256;
time = 0 ;
range = 0 ;
LMass = [];
LDrag = [];
LTime = [];
Lrange = [];
LVelocity = [];
LFuelRemain = [];
while Mass >= MinMass 
    Drag = 1/2*rho*Velocity^2*Sref*CDenduranceop;
    Power =Drag*Velocity/0.8 ;
    Fuelmassflow = Power*SFCc*5;
    Mass = Mass - Fuelmassflow;
    Weight = Mass*g;
    Velocity = ((2*Weight)/(rho*CLenduranceop*Sref))^0.5;
    time = time + 5;
    range = Velocity*5 + range ;
    FuelRemain = (((Mass  - MinMass)/800)*1000)+100;
    LMass = [LMass,Mass];
    LDrag = [LDrag,Drag];
    LTime = [LTime,time];
    Lrange = [Lrange,range];
    LVelocity = [LVelocity,Velocity];
    LFuelRemain = [LFuelRemain,FuelRemain];
end

%% B II plot 

subplot(2,2,1)
plot(LTime,LMass);
xlabel('Time (s)');
ylabel('Aircraft Mass (kg/s)');
title('Aircraft Mass vs Time')

subplot(2,2,2)
plot(LTime,LVelocity);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Velocity vs Time')

subplot(2,2,3)
plot(LTime,Lrange);
xlabel('Time (s)');
ylabel('Range (m)');
title('Range vs Time')

subplot(2,2,4)
plot(LTime,LFuelRemain);
xlabel('Time (s)');
ylabel('Fuel Remaining (l)');
title('Fuel Remaining vs Time')

%% Task 2 

throttlechosen = [];
powerchosen = [];
dragchosen = [];
timechosen = [];
Velocity = 70;
Velocitytarget = 70;
deltatime = 1 ;
posX = 0 ;
PosY = 0;
Mass = 2500;
FM = ((MFV-200)/1000)* FD; % in kg
MinMass = MaxMass - FM;
altitude = 0;
time = 0 ;
rho = 1.225;
CL = 0.80;
CD  = CDmin + K*(CL-CL_at_CDmin)^2;
Weight = Mass*g;
throttle = linspace(0,1,1000);
Power = Pmc.*throttle;
rho = 1.225;
CL = 0.80;
CD  = CDmin + K*(CL-CL_at_CDmin)^2;
FuelFlow = SFCmc*Power;
Mass = Mass - FuelFlow*deltatime;
Weight = Mass*g;
thrust = PEfficiency.*Power./Velocity;
Drag = 0.5*rho*Velocity^2*Sref*CD;
gamma = deg2rad(8); 
bank = deg2rad(0);
a = (thrust - Drag - Weight*sin(gamma))./Mass;
Velocitynew = Velocity + deltatime*a; 
error = abs(Velocitynew - Velocitytarget);
[~,idx] = min(error);
Velocity = Velocitynew(idx);
altitude = altitude + Velocity*sin(gamma)*deltatime;
rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
time = time + deltatime;
posX = posX + Velocity*cos(bank);
PosY = PosY + Velocity*sin(bank);
throttlechosen = [throttlechosen,throttle(idx)];
powerchosen = [powerchosen,Power(idx)];
dragchosen = [dragchosen,Drag];
timechosen = [timechosen,time];


%% climb
gamma = deg2rad(8); 
bank = deg2rad(0);
Velocitytarget = 70;

  while altitude < 6096 
        Power = Pmc.*throttle;
        FuelFlow = SFCmc*Power;
        Mass = Mass - FuelFlow*deltatime;
        Weight = Mass*g;
        thrust = PEfficiency.*Power./Velocity;
        Drag = 0.5*rho*Velocity^2*Sref*CD;
        a = (thrust - Drag - Weight*sin(gamma))./Mass;
        Velocitynew = Velocity + deltatime*a; 
        error = abs(Velocitynew - Velocitytarget);
        [~,idx] = min(error);
        Velocity = Velocitynew(idx);
        altitude = altitude + Velocity*sin(gamma)*deltatime;
        rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
        time = time + deltatime;
        posX = posX + Velocity*cos(bank);
        PosY = PosY + Velocity*sin(bank);
        throttlechosen = [throttlechosen,throttle(idx)];
        powerchosen = [powerchosen,Power(idx)];
        dragchosen = [dragchosen,Drag];
        timechosen = [timechosen,time];
  end
%% Cruise
gamma = deg2rad(0); 
bank = deg2rad(0);
Velocitytarget = 70;
CruiseDistance = 150000; 

while posX <= CruiseDistance
    Power = Pmc.*throttle;
    FuelFlow = SFCmc*Power;
    Mass = Mass - FuelFlow*deltatime;
    Weight = Mass*g;
    thrust = PEfficiency.*Power./Velocity;
    Drag = 0.5*rho*Velocity^2*Sref*CD; 
    a = (thrust - Drag - Weight*sin(gamma))./Mass;
    Velocitynew = Velocity + deltatime*a; 
    error = abs(Velocitynew - Velocitytarget);
    [~,idx] = min(error);
    Velocity = Velocitynew(idx);
    altitude = altitude + Velocity*sin(gamma)*deltatime;
    rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
    time = time + deltatime;
    posX = posX + Velocity*cos(bank);
    PosY = PosY + Velocity*sin(bank);
    throttlechosen = [throttlechosen,throttle(idx)];
    powerchosen = [powerchosen,Power(idx)];
    dragchosen = [dragchosen,Drag];
    timechosen = [timechosen,time];

end

%% loiter
gamma = deg2rad(0); 
bank = deg2rad(10);
Velocitytarget = 70;
CruiseDistance = 150000; 
psi = 0 ;
while psi <= 360
    Power = Pmc.*throttle;
    FuelFlow = SFCmc*Power;
    Mass = Mass - FuelFlow*deltatime;
    Weight = Mass*g;
    thrust = PEfficiency.*Power./Velocity;
    Drag = 0.5*rho*Velocity^2*Sref*CD; 
    a = (thrust - Drag - Weight*sin(gamma))./Mass;
    Velocitynew = Velocity + deltatime*a; 
    error = abs(Velocitynew - Velocitytarget);
    [~,idx] = min(error);
    Velocity = Velocitynew(idx);
    omega = 9.81*tan(bank)/Velocity;
    psi = psi + rad2deg(omega)*deltatime;
    altitude = altitude + Velocity*sin(gamma)*deltatime;
    rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
    time = time + deltatime;
    posX = posX + Velocity*cos(bank);
    PosY = PosY + Velocity*sin(bank);
    throttlechosen = [throttlechosen,throttle(idx)];
    powerchosen = [powerchosen,Power(idx)];
    dragchosen = [dragchosen,Drag];
    timechosen = [timechosen,time];

end

%% Cruise 2 
gamma = deg2rad(0); 
bank = deg2rad(10);
Velocitytarget = 70;
 

while Mass >= MinMass
    Power = Pmc.*throttle;
    FuelFlow = SFCmc*Power;
    Mass = Mass - FuelFlow*deltatime;
    Weight = Mass*g;
    thrust = PEfficiency.*Power./Velocity;
    Drag = 0.5*rho*Velocity^2*Sref*CD;
    a = (thrust - Drag - Weight*sin(gamma))./Mass;
    Velocitynew = Velocity + deltatime*a; 
    error = abs(Velocitynew - Velocitytarget);
    [~,idx] = min(error);
    Velocity = Velocitynew(idx);
    altitude = altitude + Velocity*sin(gamma)*deltatime;
    rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
    time = time + deltatime;
    posX = posX + Velocity*cos(bank);
    PosY = PosY + Velocity*sin(bank);
    throttlechosen = [throttlechosen,throttle(idx)];
    powerchosen = [powerchosen,Power(idx)];
    dragchosen = [dragchosen,Drag];
    timechosen = [timechosen,time];

end

%% Descent 
gamma = deg2rad(-3); 
bank = deg2rad(0);
Velocitytarget = 70;


while altitude >= 50
    Power = Pmc.*throttle;
    FuelFlow = SFCmc*Power;
    Mass = Mass - FuelFlow*deltatime;
    Weight = Mass*g;
    thrust = PEfficiency.*Power./Velocity;
    Drag = 0.5*rho*Velocity^2*Sref*CD;
    a = (thrust - Drag - Weight*sin(gamma))./Mass;
    Velocitynew = Velocity + deltatime*a; 
    error = abs(Velocitynew - Velocitytarget);
    [~,idx] = min(error);
    Velocity = Velocitynew(idx);
    altitude = altitude + Velocity*sin(gamma)*deltatime;
    rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
    time = time + deltatime;
    posX = posX + Velocity*cos(bank);
    PosY = PosY + Velocity*sin(bank);
    throttlechosen = [throttlechosen,throttle(idx)];
    powerchosen = [powerchosen,Power(idx)];
    dragchosen = [dragchosen,Drag];
    timechosen = [timechosen,time];

end

%% Land

gamma = deg2rad(-3); 
bank = deg2rad(0);
Velocitytarget = 0;


while Velocity >= 0
    Power = Pmc.*throttle;
    FuelFlow = SFCmc*Power;
    Mass = Mass - FuelFlow*deltatime;
    Weight = Mass*g;
    thrust = PEfficiency.*Power./Velocity;
    Drag = 0.5*rho*Velocity^2*Sref*CD;
    a = (thrust - Drag - Weight*sin(gamma))./Mass;
    Velocitynew = Velocity + deltatime*a; 
    error = abs(Velocitynew - Velocitytarget);
    [~,idx] = min(error);
    Velocity = Velocitynew(idx);
    altitude = altitude + Velocity*sin(gamma)*deltatime;
    rho = 1.225*((288.15 - 0.0065*altitude)/288.15)^4.256;
    time = time + deltatime;
    posX = posX + Velocity*cos(bank);
    PosY = PosY + Velocity*sin(bank);
    throttlechosen = [throttlechosen,throttle(idx)];
    powerchosen = [powerchosen,Power(idx)];
    dragchosen = [dragchosen,Drag];
    timechosen = [timechosen,time];

end

%% Plot 
subplot(2,2,1)
plot(timechosen,throttlechosen.*100);
xlabel('Time (s)');
ylabel('throttle ');
title('throttle vs Time')

subplot(2,2,2)
plot(timechosen,powerchosen);
xlabel('Time (s)');
ylabel('power (W)');
title('Power vs Time')

subplot(2,2,3)
plot(timechosen,dragchosen);
xlabel('Time (s)');
ylabel('Drag (N)');
title('Drag vs Time')



