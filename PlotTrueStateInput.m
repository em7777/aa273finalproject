function PlotTrueStateInput(xTrue,uTrue);

figure(1);
subplot(2,3,1);
plot(xTrue(1,:));
title('x_{21}')

subplot(2,3,2);
plot(xTrue(2,:));
title('y_{21}')

subplot(2,3,3);
plot(xTrue(3,:));
title('theta_{21}')

subplot(2,3,4);
plot(xTrue(4,:));
title('x_{12}')

subplot(2,3,5);
plot(xTrue(5,:));
title('y_{12}')

subplot(2,3,6);
plot(xTrue(6,:));
title('theta_{12}')

figure(2);
subplot(1,4,1);
plot(uTrue(1,:));
title('v_1')

subplot(1,4,2);
plot(uTrue(2,:));
title('omega_1')

subplot(1,4,3);
plot(uTrue(3,:));
title('v_2')

subplot(1,4,4);
plot(uTrue(4,:));
title('omega_2')

end