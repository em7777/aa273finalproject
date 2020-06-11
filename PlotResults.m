function PlotResults(xTrue,uTrue,yMeas,xCorrectedUKF,xCorrectedEKF,e,residualEKF,timeVector)
xCorrectedUKF = xCorrectedUKF';
xCorrectedEKF = xCorrectedEKF';

figure(3);
subplot(2,3,1);
plot(timeVector,xTrue(1,:));
title('x_{21}')
hold on;
plot(timeVector,xCorrectedUKF(1,:));
hold on;
plot(timeVector,xCorrectedEKF(1,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

%ylim([-1,1])

subplot(2,3,2);
plot(timeVector,xTrue(2,:));
title('y_{21}')
hold on;
plot(timeVector,xCorrectedUKF(2,:));
hold on;
plot(timeVector,xCorrectedEKF(2,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

%ylim([-2,0])

subplot(2,3,3);
plot(timeVector,xTrue(3,:));
title('theta_{21}')
hold on;
plot(timeVector,xCorrectedUKF(3,:));
hold on;
plot(timeVector,xCorrectedEKF(3,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

%ylim([-1,1])

subplot(2,3,4);
plot(timeVector,xTrue(4,:));
title('x_{12}')
hold on;
plot(timeVector,xCorrectedUKF(4,:));
hold on;
plot(timeVector,xCorrectedEKF(4,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

%ylim([-1,1])

subplot(2,3,5);
plot(timeVector,xTrue(5,:));
title('y_{12}')
hold on;
plot(timeVector,xCorrectedUKF(5,:));
hold on;
plot(timeVector,xCorrectedEKF(5,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

%ylim([0, 2])

subplot(2,3,6);
plot(timeVector,xTrue(6,:));
title('theta_{12}')
hold on;
plot(timeVector,xCorrectedUKF(6,:));
hold on;
plot(timeVector,xCorrectedEKF(6,:));
grid on;
legend('True State','UKF Estimate','EKF Estimate')

figure(4)
plot(timeVector,vecnorm(e',1));
hold on;
plot(timeVector,vecnorm(residualEKF',1));
title('Norm of Residual')
legend('UKF','EKF');

disp('UKF sum residuals')
sum(vecnorm(e',1))
disp('EKF sum residuals')
sum(vecnorm(residualEKF',1))
%ylim([-1,1])
% 
% figure(4);
% subplot(1,4,1);
% plot(uTrue(1,:));
% hold on;
% plot(yMeas(3,:));
% title('v_1')
% 
% subplot(1,4,2);
% plot(uTrue(2,:));
% hold on;
% plot(yMeas(4,:));
% title('omega_1')
% 
% subplot(1,4,3);
% plot(uTrue(3,:));
% hold on;
% plot(yMeas(5,:));
% title('v_2')
% 
% subplot(1,4,4);
% plot(uTrue(4,:));
% hold on;
% plot(yMeas(6,:));
% title('omega_2')

end