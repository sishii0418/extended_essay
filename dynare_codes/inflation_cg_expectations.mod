// Dynare script: C-G Household Expectations Extension
// ベースラインに家計インフレ期待(exp_h)を追加
// 理論的根拠: Coibion & Gorodnichenko (2015)
// π_t = κ*X_t + β*E_t π_{t+1} + ω*ê_t
// ê_t = ρ_e * ê_{t-1} + φ_e * ŝ_t

// Endogenous variables（exp_hを追加）
var infl cpi resetprice gdp employ nomint rwage rmc nmc tot exp_h;

// Exogenous variables
varexo totsh;

// Parameters（rho_e, phi_e, omegaを追加）
parameters alph, bet, theta, intsub, frisch, phi, chipi, chiy, rho,
           rho_e, phi_e, omega;

alph   = 0.15;    // エネルギーの生産コストシェア
rbar   = 2;       // 定常状態の実質金利（年率2%）
intsub = 0.5;     // 異時点間代替弾力性
frisch = 3;       // フリッシュ弾力性
theta  = 11/12;   // Calvo確率
phi    = 0.9;     // 金利スムージング
chipi  = 3;       // テイラールール：インフレ応答
chiy   = 0.5;     // テイラールール：GDP応答
rho    = 0.8;     // totショックの持続性

// 家計インフレ期待パラメータ
// -------------------------------------------
// rho_e: 家計期待の持続性
//   ベースとなるtotよりも高め（0.9）に設定
//   C-G (2015): 原油価格「水準」が期待を駆動（Table 4, Panel A）
//   → ショック消滅後も期待がゆっくり減衰することを反映

rho_e  = 0.9;

// phi_e: エネルギー価格への家計期待の感応度
//   C-G (2015) Table 4, col.(1): OilP係数 = 0.026（ドル建て）
//   ここではtotはlog偏差のため直接適用不可
//   エネルギーコストシェアalph=0.15を参考に控えめに設定

phi_e  = 0.1;

// omega: reset price方程式における家計期待のウェイト
//   C-G (2015): firms' expectations ≈ household expectations
//   Calvo fractionとの整合性を考慮して0.3に設定
//   感度分析の対象とすることを推奨

omega  = 0.3;
// -------------------------------------------

bet = (1/(1+(rbar/100)))^(1/12);

model(linear);

// 集計的生産関数
gdp = employ - alph*tot;

// 実質限界費用
rmc = rwage + alph*tot;

// 名目限界費用
nmc = rmc + cpi;

// 労働供給曲線
rwage = (1/intsub)*gdp + (1/frisch)*employ;

// インフレ定義
infl = 12*(cpi - cpi(-1));

// Calvo価格粘着性
cpi = theta*cpi(-1) + (1-theta)*resetprice;

// 修正されたreset price方程式
// ベースライン: resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc
// 追加項 omega*exp_h: 家計インフレ期待による追加的価格引き上げ圧力
// 解釈: π_t = κ*mc_t + β*E_t π_{t+1} + ω*ê_t
resetprice = bet*theta*resetprice(+1) + (1-bet*theta)*nmc + omega*exp_h;

// IS方程式
gdp = gdp(+1) - intsub*((nomint/12) - (infl(+1)/12));

// テイラールール
nomint = phi*nomint(-1) + (1-phi)*(chipi*infl + 12*chiy*gdp);

// totの外生的AR(1)過程
tot = rho*tot(-1) + totsh;

// 家計インフレ期待（新たな状態変数）
// ê_t = ρ_e * ê_{t-1} + φ_e * ŝ_t
// - totショックによって即座に上方修正される
// - totが消滅した後もρ_eの速度でゆっくり減衰 → インフレ持続性の源泉
exp_h = rho_e*exp_h(-1) + phi_e*tot;

end;

shocks;
var totsh; stderr 100;
end;

stoch_simul(irf=24,order=1) infl gdp tot nomint exp_h;
