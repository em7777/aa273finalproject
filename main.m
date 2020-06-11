clc; clear; close all;

nx = 6; ny = 6; nu = 4; nd = ny - nu;
dt = 0.05;
R = 0.1*eye(ny); %Q << R 
Q = dt*eye(nu);
P0 = 1*eye(nx);
type TCStateFun
type TCMeasurementFun

%initial state guess
x0 = [4;-2.3;0.5;0.7;0.7;4];%[6;-3;0.8;2;3;3.5]; + 
x0real = [4;-2.3;0.5;0.7;0.7;4];

%construct the filter
ukf = unscentedKalmanFilter(...
    @TCStateFun, ...
    @TCMeasurementFun, ...
    x0, 'HasAdditiveProcessNoise', false);

ukf.StateCovariance = P0;
ukf.ProcessNoise = Q; 
ukf.MeasurementNoise = R;

ekf = extendedKalmanFilter(...
    @TCStateFun, ...
    @TCMeasurementFun, ...
    x0, 'HasAdditiveProcessNoise', false);

ekf.StateCovariance = P0;
ekf.ProcessNoise = Q; 
ekf.MeasurementNoise = R;


%process noise incorporated into model

% Obtain true states of system
T = 12;
timeVector = 0:dt:T;
numSteps = length(timeVector);
u1 = 0.75; u2 = 0.5; u3 = 2.0; u4 = -1.0;
uTrue = [u1*ones(1,numSteps); u2*ones(1,numSteps); ...
         u3*ones(1,numSteps); u4*ones(1,numSteps)]; %v1, v2 = 1, w1, w2 = 0
     
xTrue = [x0real];
for i=2:numSteps
    xTrue = [xTrue, TCStateFun(xTrue(:,i-1),mvnrnd(zeros(nu,1),Q)',uTrue(:,i-1))];
end

% Plot true states and input of system 
% PlotTrueStateInput(xTrue,uTrue);

u = uTrue;
yMeas = [zeros(nd,numSteps); zeros(size(u))];
for i=1:numSteps
    yMeas(1:nd,i) = [sqrt(xTrue(1,i)^2 + xTrue(2,i)^2); ...
                    sqrt(xTrue(4,i)^2 + xTrue(5,i)^2)];
    yMeas(3:end,i) = u(:,i);
    yMeas(:,i) = yMeas(:,i) + mvnrnd(zeros(nd+nu,1),R)';
end

xCorrectedUKF = zeros(numSteps,nx);
PCorrected = zeros(numSteps, nx, nx);
e = zeros(numSteps,ny);

xCorrectedEKF = zeros(numSteps,nx);
PCorrectedEKF = zeros(numSteps, nx, nx);
residualEKF = zeros(numSteps,ny);
rescov = zeros(numSteps,nx,nx);

%online estimation (UKF)
tic
for k=1:numSteps
    % Let k denote the current time.
    % Residuals (or innovations): Measured output - Predicted output
    e(k,:) = yMeas(:,k)' - TCMeasurementFun(ukf.State,uTrue(:,k))';
    % ukf.State is x[k|k-1] at this point
    % Incorporate the measurements at time k into the state estimates by
    % using the "correct" command. This updates the State and StateCovariance
    % properties of the filter to contain x[k|k] and P[k|k]. These values
    % are also produced as the output of the "correct" command.
    [xCorrectedUKF(k,:), PCorrected(k,:,:)] = correct(ukf,yMeas(:,k),uTrue(:,k));
    % Predict the states at next time step, k+1. This updates the State and
    % StateCovariance properties of the filter to contain x[k+1|k] and
    % P[k+1|k]. These will be utilized by the filter at the next time step.
    predict(ukf,uTrue(:,k));
end
toc


%online estimation (EKF)
tic
for k=1:numSteps

    residualEKF(k,:) = yMeas(:,k)' - TCMeasurementFun(ekf.State,uTrue(:,k))';
    [xCorrectedEKF(k,:), PCorrectedEKF(k,:,:)] = correct(ekf,yMeas(:,k),uTrue(:,k));

    predict(ekf,uTrue(:,k));
end
toc

PlotResults(xTrue,uTrue,yMeas,xCorrectedUKF,xCorrectedEKF,e,residualEKF,timeVector);