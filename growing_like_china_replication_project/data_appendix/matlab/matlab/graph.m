employ_share_manufacturing=[12.07512997	4.114026066
14.06300632	6.32230219
19.81769753	10.36667295
26.30368246	16.83449346
32.40902132	23.21853428
40.01641813	32.2084207
49.86788618	43.43862868
52.41316294	47.43828761
55.89134209	52.21192053
58.67037837	56.38043089
];

employ_share_aggregate=[5.360913127
6.989796238
9.492810601
12.06276175
13.55995365
15.39446514
20.75922536
22.74823986
23.21568627
25.31522928
28.7854464
31.93245146
34.27403066
36.49744826
38.43310753
40.84791386
];

close all
plot([1998:2007],employ_share_manufacturing(:,1),'-','color','b','linewidth',2)
hold on
plot([1998:2007],employ_share_manufacturing(:,2),'-.','color','g','linewidth',2)
hold on
plot([1992:2007],employ_share_aggregate,':','color','r','linewidth',2)
hold off
legend('industrial firms - firm data','industrial firms - CSY','aggregate data - CLSY')
xlabel('year')
title('private employment share (percentage)')
% legend('model','data')
print -f1 -r600 -depsc 'employment share'
