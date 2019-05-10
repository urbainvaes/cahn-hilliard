s1 = .2;
s2 = .2;

/*{{{ External points */

Point(1686) = {3.5140715729624,     19.9319443415322,      0, s1};
Point(1687) = {4.560043307214,      17.3361911575828,      0, s1};
Point(1688) = {4.6500120911624,     17.1831725425612,      0, s1};
Point(1689) = {4.7808156185312,     17.063174602992,       0, s1};
Point(1690) = {4.941005281703199,   16.986700106278,       0, s1};
Point(1691) = {5.1165604465532,     16.960442526271,       0, s1};
Point(1692) = {5.711453101,         16.960442529,          0, s1};
Point(2307) = {5.8114531007708,     26.2904425250194,      0, s1};
Point(2309) = {5.711453101,         24.435442529,          0, s1};
Point(2310) = {5.117773405914001,   24.435442527352,       0, s1};
Point(2311) = {4.9418203046064,     24.4090630407876,      0, s1};
Point(2312) = {4.781339044159199,   24.3322442276704,      0, s1};
Point(2313) = {4.650440992751999,   24.2117408326584,      0, s1};
Point(2314) = {4.5606362066244,     24.0581489310716,      0, s1};
Point(2315) = {3.5124756654572,     21.4360006553258,      0, s1};
Point(2361) = {6.4114531012292,     26.2904425250194,      0, s1};
Point(3265) = {5.811453101,         24.425442529,          0, s1};
Point(1615) = {6.411453101,         16.960442526271,          0, s1};
Point(1693) = {5.811453101,         16.960442526271,          0, s1};
Point(2308) = {5.811453101,         24.425442529,          0, s1};
Point(2360) = {6.411453101,         24.425442529,          0, s1};

/*}}}*/
// Additional points {{{*/

Point(1540) = {5.8114531007708, 10,    0, s1};
Point(1548) = {6.4114531012292, 10,    0, s1};

pb1[] = Point{1540};
pb2[] = Point{1548};

paux1[] = Point{2315};
paux2[] = Point{1686};

np1 = newp; Point(np1) = {paux1[0] - 1, paux1[1], 0, s1};
np2 = newp; Point(np2) = {paux2[0] - 1, paux2[1], 0, s1};


/*}}}*/
/*{{{ External lines */

Line(2307) = {2307, 2308};
Line(2308) = {2308, 2309};
Line(1692) = {1692, 1693};
Line(2309) = {2309, 2310};
Line(1691) = {1691, 1692};
Line(1686) = {1686, 1687};
p1687 = newp;/*{{{*/
Point(p1687 + 1) = {4.563454622982933, 17.32790103836301, 0};
Point(p1687 + 2) = {4.566980373504369, 17.31967820791541, 0};
Point(p1687 + 3) = {4.570620557992308, 17.3115226598228, 0};
Point(p1687 + 4) = {4.574375176446752, 17.30343439408517, 0};
Point(p1687 + 5) = {4.578244228867701, 17.29541341070253, 0};
Point(p1687 + 6) = {4.582227715255152, 17.28745970967487, 0};
Point(p1687 + 7) = {4.586325635609109, 17.2795732910022, 0};
Point(p1687 + 8) = {4.590537989929569, 17.27175415468451, 0};
Point(p1687 + 9) = {4.594864778216532, 17.26400230072181, 0};
Point(p1687 + 10) = {4.59930600047, 17.2563177291141, 0};
Point(p1687 + 11) = {4.603861656689973, 17.24870043986137, 0};
Point(p1687 + 12) = {4.608531746876449, 17.24115043296363, 0};
Point(p1687 + 13) = {4.613316271029428, 17.23366770842088, 0};
Point(p1687 + 14) = {4.618215229148912, 17.22625226623311, 0};
Point(p1687 + 15) = {4.623228621234901, 17.21890410640033, 0};
Point(p1687 + 16) = {4.628356447287392, 17.21162322892253, 0};
Point(p1687 + 17) = {4.633598707306389, 17.20440963379972, 0};
Point(p1687 + 18) = {4.638955401291889, 17.19726332103189, 0};
Point(p1687 + 19) = {4.644426529243892, 17.19018429061905, 0};
Spline(1687) = {1687, p1687 + 1, p1687 + 2, p1687 + 3, p1687 + 4, p1687 + 5, p1687 + 6, p1687 + 7, p1687 + 8, p1687 + 9, p1687 + 10, p1687 + 11, p1687 + 12, p1687 + 13, p1687 + 14, p1687 + 15, p1687 + 16, p1687 + 17, p1687 + 18, p1687 + 19, 1688};/*}}}*/
p1688 = newp;/*{{{*/
Point(p1688 + 1) = {4.655699739937494, 17.17624335028112, 0};
Point(p1688 + 2) = {4.661477128459255, 17.1694119785591, 0};
Point(p1688 + 3) = {4.667344256727685, 17.16267842739514, 0};
Point(p1688 + 4) = {4.673301124742784, 17.15604269678925, 0};
Point(p1688 + 5) = {4.679347732504549, 17.14950478674143, 0};
Point(p1688 + 6) = {4.685484080012984, 17.14306469725167, 0};
Point(p1688 + 7) = {4.691710167268086, 17.13672242831998, 0};
Point(p1688 + 8) = {4.698025994269856, 17.13047797994636, 0};
Point(p1688 + 9) = {4.704431561018294, 17.1243313521308, 0};
Point(p1688 + 10) = {4.7109268675134, 17.1182825448733, 0};
Point(p1688 + 11) = {4.717511913755174, 17.11233155817387, 0};
Point(p1688 + 12) = {4.724186699743615, 17.10647839203251, 0};
Point(p1688 + 13) = {4.730951225478726, 17.10072304644922, 0};
Point(p1688 + 14) = {4.737805490960504, 17.09506552142399, 0};
Point(p1688 + 15) = {4.74474949618895, 17.08950581695683, 0};
Point(p1688 + 16) = {4.751783241164063, 17.08404393304773, 0};
Point(p1688 + 17) = {4.758906725885846, 17.0786798696967, 0};
Point(p1688 + 18) = {4.766119950354296, 17.07341362690373, 0};
Point(p1688 + 19) = {4.773422914569414, 17.06824520466883, 0};
Spline(1688) = {1688, p1688 + 1, p1688 + 2, p1688 + 3, p1688 + 4, p1688 + 5, p1688 + 6, p1688 + 7, p1688 + 8, p1688 + 9, p1688 + 10, p1688 + 11, p1688 + 12, p1688 + 13, p1688 + 14, p1688 + 15, p1688 + 16, p1688 + 17, p1688 + 18, p1688 + 19, 1689};/*}}}*/
p1689 = newp;/*{{{*/
Point(p1689 + 1) = {4.788281787832494, 17.05821280581713, 0};
Point(p1689 + 2) = {4.795805148066136, 17.05337080573059, 0};
Point(p1689 + 3) = {4.803385699232126, 17.04864860273238, 0};
Point(p1689 + 4) = {4.811023441330464, 17.04404619682251, 0};
Point(p1689 + 5) = {4.818718374361151, 17.03956358800097, 0};
Point(p1689 + 6) = {4.826470498324184, 17.03520077626777, 0};
Point(p1689 + 7) = {4.834279813219566, 17.0309577616229, 0};
Point(p1689 + 8) = {4.842146319047296, 17.02683454406637, 0};
Point(p1689 + 9) = {4.850070015807374, 17.02283112359817, 0};
Point(p1689 + 10) = {4.8580509034998, 17.0189475002183, 0};
Point(p1689 + 11) = {4.866088982124574, 17.01518367392677, 0};
Point(p1689 + 12) = {4.874184251681696, 17.01153964472357, 0};
Point(p1689 + 13) = {4.882336712171166, 17.0080154126087, 0};
Point(p1689 + 14) = {4.890546363592984, 17.00461097758217, 0};
Point(p1689 + 15) = {4.89881320594715, 17.00132633964397, 0};
Point(p1689 + 16) = {4.907137239233664, 16.99816149879411, 0};
Point(p1689 + 17) = {4.915518463452526, 16.99511645503258, 0};
Point(p1689 + 18) = {4.923956878603735, 16.99219120835939, 0};
Point(p1689 + 19) = {4.932452484687293, 16.98938575877453, 0};
Spline(1689) = {1689, p1689 + 1, p1689 + 2, p1689 + 3, p1689 + 4, p1689 + 5, p1689 + 6, p1689 + 7, p1689 + 8, p1689 + 9, p1689 + 10, p1689 + 11, p1689 + 12, p1689 + 13, p1689 + 14, p1689 + 15, p1689 + 16, p1689 + 17, p1689 + 18, p1689 + 19, 1690};/*}}}*/
p1690 = newp;/*{{{*/
Point(p1690 + 1) = {4.949596492474682, 16.98413999196124, 0};
Point(p1690 + 2) = {4.958207339824974, 16.98171116555816, 0};
Point(p1690 + 3) = {4.966837823754075, 16.97941362706876, 0};
Point(p1690 + 4) = {4.975487944261983, 16.97724737649304, 0};
Point(p1690 + 5) = {4.984157701348699, 16.975212413831, 0};
Point(p1690 + 6) = {4.992847095014223, 16.97330873908264, 0};
Point(p1690 + 7) = {5.001556125258555, 16.97153635224796, 0};
Point(p1690 + 8) = {5.010284792081695, 16.96989525332696, 0};
Point(p1690 + 9) = {5.019033095483643, 16.96838544231964, 0};
Point(p1690 + 10) = {5.027801035464399, 16.967006919226, 0};
Point(p1690 + 11) = {5.036588612023963, 16.96575968404604, 0};
Point(p1690 + 12) = {5.045395825162335, 16.96464373677976, 0};
Point(p1690 + 13) = {5.054222674879515, 16.96365907742716, 0};
Point(p1690 + 14) = {5.063069161175503, 16.96280570598824, 0};
Point(p1690 + 15) = {5.071935284050299, 16.962083622463, 0};
Point(p1690 + 16) = {5.080821043503903, 16.96149282685144, 0};
Point(p1690 + 17) = {5.089726439536315, 16.96103331915356, 0};
Point(p1690 + 18) = {5.098651472147535, 16.96070509936936, 0};
Point(p1690 + 19) = {5.107596141337563, 16.96050816749884, 0};
Spline(1690) = {1690, p1690 + 1, p1690 + 2, p1690 + 3, p1690 + 4, p1690 + 5, p1690 + 6, p1690 + 7, p1690 + 8, p1690 + 9, p1690 + 10, p1690 + 11, p1690 + 12, p1690 + 13, p1690 + 14, p1690 + 15, p1690 + 16, p1690 + 17, p1690 + 18, p1690 + 19, 1691};/*}}}*/
p2310 = newp;/*{{{*/
Point(p2310 + 1) = {5.108787894666463, 24.43537657699171, 0};
Point(p2310 + 2) = {5.099822156931289, 24.43517873085484, 0};
Point(p2310 + 3) = {5.090876193622479, 24.43484898729338, 0};
Point(p2310 + 4) = {5.081950004740033, 24.43438734630734, 0};
Point(p2310 + 5) = {5.073043590283951, 24.43379380789673, 0};
Point(p2310 + 6) = {5.064156950254233, 24.43306837206152, 0};
Point(p2310 + 7) = {5.055290084650879, 24.43221103880174, 0};
Point(p2310 + 8) = {5.046442993473889, 24.43122180811738, 0};
Point(p2310 + 9) = {5.037615676723263, 24.43010068000843, 0};
Point(p2310 + 10) = {5.028808134399, 24.4288476544749, 0};
Point(p2310 + 11) = {5.020020366501102, 24.42746273151679, 0};
Point(p2310 + 12) = {5.011252373029568, 24.4259459111341, 0};
Point(p2310 + 13) = {5.002504153984399, 24.42429719332682, 0};
Point(p2310 + 14) = {4.993775709365592, 24.42251657809497, 0};
Point(p2310 + 15) = {4.98506703917315, 24.42060406543853, 0};
Point(p2310 + 16) = {4.976378143407072, 24.41855965535751, 0};
Point(p2310 + 17) = {4.967709022067358, 24.4163833478519, 0};
Point(p2310 + 18) = {4.959059675154008, 24.41407514292172, 0};
Point(p2310 + 19) = {4.950430102667021, 24.41163504056695, 0};
Spline(2310) = {2310, p2310 + 1, p2310 + 2, p2310 + 3, p2310 + 4, p2310 + 5, p2310 + 6, p2310 + 7, p2310 + 8, p2310 + 9, p2310 + 10, p2310 + 11, p2310 + 12, p2310 + 13, p2310 + 14, p2310 + 15, p2310 + 16, p2310 + 17, p2310 + 18, p2310 + 19, 2311};/*}}}*/
p2311 = newp;/*{{{*/
Point(p2311 + 1) = {4.933249187323121, 24.40636494679293, 0};
Point(p2311 + 2) = {4.924735654698887, 24.40354655314971, 0};
Point(p2311 + 3) = {4.916279706733698, 24.40060785985794, 0};
Point(p2311 + 4) = {4.907881343427552, 24.39754886691763, 0};
Point(p2311 + 5) = {4.89954056478045, 24.39436957432877, 0};
Point(p2311 + 6) = {4.891257370792392, 24.39106998209137, 0};
Point(p2311 + 7) = {4.883031761463378, 24.38765009020542, 0};
Point(p2311 + 8) = {4.874863736793407, 24.38410989867093, 0};
Point(p2311 + 9) = {4.866753296782481, 24.38044940748789, 0};
Point(p2311 + 10) = {4.858700441430599, 24.3766686166563, 0};
Point(p2311 + 11) = {4.850705170737761, 24.37276752617617, 0};
Point(p2311 + 12) = {4.842767484703967, 24.36874613604749, 0};
Point(p2311 + 13) = {4.834887383329217, 24.36460444627026, 0};
Point(p2311 + 14) = {4.827064866613512, 24.36034245684449, 0};
Point(p2311 + 15) = {4.819299934556849, 24.35596016777017, 0};
Point(p2311 + 16) = {4.811592587159232, 24.35145757904731, 0};
Point(p2311 + 17) = {4.803942824420657, 24.3468346906759, 0};
Point(p2311 + 18) = {4.796350646341127, 24.34209150265595, 0};
Point(p2311 + 19) = {4.788816052920641, 24.33722801498745, 0};
Spline(2311) = {2311, p2311 + 1, p2311 + 2, p2311 + 3, p2311 + 4, p2311 + 5, p2311 + 6, p2311 + 7, p2311 + 8, p2311 + 9, p2311 + 10, p2311 + 11, p2311 + 12, p2311 + 13, p2311 + 14, p2311 + 15, p2311 + 16, p2311 + 17, p2311 + 18, p2311 + 19, 2312};/*}}}*/
p2312 = newp;/*{{{*/
Point(p2312 + 1) = {4.773935993420358, 24.32715122889862, 0};
Point(p2312 + 2) = {4.766623274067672, 24.32196010686591, 0};
Point(p2312 + 3) = {4.759400886101142, 24.31667086157227, 0};
Point(p2312 + 4) = {4.752268829520768, 24.3112834930177, 0};
Point(p2312 + 5) = {4.74522710432655, 24.3057980012022, 0};
Point(p2312 + 6) = {4.738275710518488, 24.30021438612578, 0};
Point(p2312 + 7) = {4.731414648096582, 24.29453264778843, 0};
Point(p2312 + 8) = {4.724643917060832, 24.28875278619014, 0};
Point(p2312 + 9) = {4.717963517411238, 24.28287480133094, 0};
Point(p2312 + 10) = {4.7113734491478, 24.2768986932108, 0};
Point(p2312 + 11) = {4.704873712270518, 24.27082446182974, 0};
Point(p2312 + 12) = {4.698464306779393, 24.26465210718774, 0};
Point(p2312 + 13) = {4.692145232674422, 24.25838162928482, 0};
Point(p2312 + 14) = {4.685916489955608, 24.25201302812098, 0};
Point(p2312 + 15) = {4.679778078622951, 24.2455463036962, 0};
Point(p2312 + 16) = {4.673729998676448, 24.2389814560105, 0};
Point(p2312 + 17) = {4.667772250116102, 24.23231848506386, 0};
Point(p2312 + 18) = {4.661904832941913, 24.2255573908563, 0};
Point(p2312 + 19) = {4.656127747153878, 24.21869817338781, 0};
Spline(2312) = {2312, p2312 + 1, p2312 + 2, p2312 + 3, p2312 + 4, p2312 + 5, p2312 + 6, p2312 + 7, p2312 + 8, p2312 + 9, p2312 + 10, p2312 + 11, p2312 + 12, p2312 + 13, p2312 + 14, p2312 + 15, p2312 + 16, p2312 + 17, p2312 + 18, p2312 + 19, 2313};/*}}}*/
p2313 = newp;/*{{{*/
Point(p2313 + 1) = {4.644856970336973, 24.20470077064773, 0};
Point(p2313 + 2) = {4.639388082978775, 24.19759338933546, 0};
Point(p2313 + 3) = {4.634034330677405, 24.19041868872161, 0};
Point(p2313 + 4) = {4.628795713432863, 24.18317666880618, 0};
Point(p2313 + 5) = {4.623672231245149, 24.17586732958915, 0};
Point(p2313 + 6) = {4.618663884114263, 24.16849067107054, 0};
Point(p2313 + 7) = {4.613770672040205, 24.16104669325033, 0};
Point(p2313 + 8) = {4.608992595022976, 24.15353539612855, 0};
Point(p2313 + 9) = {4.604329653062574, 24.14595677970517, 0};
Point(p2313 + 10) = {4.599781846159, 24.1383108439802, 0};
Point(p2313 + 11) = {4.595349174312254, 24.13059758895365, 0};
Point(p2313 + 12) = {4.591031637522335, 24.12281701462551, 0};
Point(p2313 + 13) = {4.586829235789246, 24.11496912099578, 0};
Point(p2313 + 14) = {4.582741969112984, 24.10705390806446, 0};
Point(p2313 + 15) = {4.57876983749355, 24.09907137583155, 0};
Point(p2313 + 16) = {4.574912840930944, 24.09102152429706, 0};
Point(p2313 + 17) = {4.571170979425166, 24.08290435346098, 0};
Point(p2313 + 18) = {4.567544252976217, 24.07471986332331, 0};
Point(p2313 + 19) = {4.564032661584094, 24.06646805388405, 0};
Spline(2313) = {2313, p2313 + 1, p2313 + 2, p2313 + 3, p2313 + 4, p2313 + 5, p2313 + 6, p2313 + 7, p2313 + 8, p2313 + 9, p2313 + 10, p2313 + 11, p2313 + 12, p2313 + 13, p2313 + 14, p2313 + 15, p2313 + 16, p2313 + 17, p2313 + 18, p2313 + 19, 2314};
Line(2314) = {2314, 2315};/*}}}*/
Line(2360) = {2360, 2361};/*}}}*/
// Additional lines {{{*/

Line(2369) = {1693, 1540};
Line(2370) = {1548, 1615};
Line(2377) = {2307, 2361};
Line(2378) = {1540, 1548};
Line(2433) = {2315, np1};
Line(2434) = {np1, np2};
Line(2435) = {np2, 1686};
Line(2436) = {2360, 1615};
/*}}}*/
/*{{{ Points in the middle */

// Endpoints in y direction
yb = 16.960442526271;
yt = 24.425442529;

// Coordinates of the left and right rows
xl = 5.811453101;
xr = 6.411453101;

/* Parameters:
 * - n_blocks: number of blocks;
 * - delta: space between blocks;
 * - width: width of blocks.
 */

// Parameters of real device
// n_blocks = 149;
// delta = .005;
// width = .1;

n_blocks = 5;
delta = 0.1;
width = 0.3;

height = (yt - yb - delta*(n_blocks+1))/n_blocks;
period = height + delta;

// Coordinates with respect to left-right corner
x1 = 0     ; y1 = 0      ;
x2 = width ; y2 = 0      ;
x3 = width ; y3 = height ;
x4 = 0     ; y4 = height ;

inner_loops_left = {};
Physical Line("Blocks", 4) = {};

For i In {0:n_blocks - 1}
  // Left
  p = newp;
  Point(p + 0) = {xl - x1, yb + delta + i*period + y1, 0, s2};
  Point(p + 1) = {xl - x2, yb + delta + i*period + y2, 0, s2};
  Point(p + 2) = {xl - x3, yb + delta + i*period + y3, 0, s2};
  Point(p + 3) = {xl - x4, yb + delta + i*period + y4, 0, s2};

  l = newl;
  Line(l + 0) = {p + 0, p + 1};
  Line(l + 1) = {p + 1, p + 2};
  Line(l + 2) = {p + 2, p + 3};
  Line(l + 3) = {p + 3, p + 0};
  Line Loop(l + 4)  = {l + 0, l + 1, l + 2, l + 3};
  Physical Line("Blocks", 4) += {l + 0, l + 1, l + 2, l + 3};
  inner_loops_left += {l + 4};
EndFor

/*}}}*/
Geometry.Points = 1;
Geometry.Surfaces = 1;
Geometry.LineNumbers = 1;
Geometry.PointNumbers = 0;
Geometry.LabelType = 2;
Mesh.ColorCarousel = 1;

ll = newl;
Line Loop(ll) = {2314, 2433, 2434, 2435, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 2369, 2378, 2370, -2436, 2360, -2377, 2307, 2308, 2309, 2310, 2311, 2312, 2313};
Plane Surface(2371) = {ll, inner_loops_left[]};

Physical Line("Inflow", 1) = {2378};
Physical Line("Central_outflow", 2) = {2377};
Physical Line("Lateral_outflows", 3) = {2434};
Physical Line("Substrate", 5) = {2435, 2433, 2307, 2360, 2436, 2370, 2369, 1691, 1687, 1686, 1688, 1689, 1690, 1692, 2314, 2308, 2309, 2310, 2311, 2312, 2313};
Physical Surface("Domain", 1) = {2371};
