
package com.qweib.cloud.utils;

import java.util.HashMap;
import java.util.Map;

/**
 *说明：
 *@创建：作者:yxy		创建时间：2013-5-1
 *@修改历史：
 *		[序号](yxy	2013-5-1)<修改说明>
 */
public class Statics {
	public static Map<String,Double[]> coordinate;
	public static void initCoordinate(){
		coordinate = new HashMap<String, Double[]>();
		//福建省
		coordinate.put("福州", new Double[]{119.330221,26.047125});
		coordinate.put("厦门", new Double[]{118.103886,24.489231});
		coordinate.put("宁德", new Double[]{119.542082,26.656527});
		coordinate.put("莆田", new Double[]{119.077731,25.44845});
		coordinate.put("泉州", new Double[]{118.600362,24.901652});
		coordinate.put("漳州", new Double[]{117.676205,24.517065});
		coordinate.put("龙岩", new Double[]{117.017997,25.078685});
		coordinate.put("龙岩", new Double[]{117.017997,25.078685});
		coordinate.put("三明", new Double[]{117.642194,26.270835});
		coordinate.put("南平", new Double[]{118.181883,26.643626});
		//安徽省
		coordinate.put("安庆", new Double[]{117.058739,30.537898});
		coordinate.put("蚌埠", new Double[]{117.35708,32.929499});
		coordinate.put("巢湖", new Double[]{117.88049,31.608733});
		coordinate.put("池州", new Double[]{117.494477,30.660019});
		coordinate.put("滁州", new Double[]{118.32457,32.317351});
		coordinate.put("阜阳", new Double[]{115.820932,32.901211});
		coordinate.put("合肥", new Double[]{117.282699,31.866942});
		coordinate.put("淮北", new Double[]{116.791447,33.960023});
		coordinate.put("淮南", new Double[]{117.018639,32.642812});
		coordinate.put("黄山", new Double[]{118.29357,29.734435});
		coordinate.put("六安", new Double[]{116.505253,31.755558});
		coordinate.put("马鞍山", new Double[]{118.515882,31.688528});
		coordinate.put("宿州", new Double[]{116.988692,33.636772});
		coordinate.put("铜陵", new Double[]{117.819429,30.94093});
		coordinate.put("芜湖", new Double[]{118.384108,31.36602});
		coordinate.put("宣城", new Double[]{118.752096,30.951642});
		coordinate.put("亳州", new Double[]{115.787928,33.871211});
		//甘肃省
		coordinate.put("白银", new Double[]{104.171241,36.546682});
		coordinate.put("定西", new Double[]{104.626638,35.586056});
		coordinate.put("甘南藏族自治州", new Double[]{102.917442,34.992211});
		coordinate.put("金昌", new Double[]{102.208126,38.516072});
		coordinate.put("酒泉", new Double[]{98.508415,39.741474});
		coordinate.put("兰州", new Double[]{103.823305,36.064226});
		coordinate.put("临夏回族自治州", new Double[]{103.215249,35.598514});
		coordinate.put("陇南", new Double[]{104.934573,33.39448});
		coordinate.put("平凉", new Double[]{106.688911,35.55011});
		coordinate.put("庆阳", new Double[]{107.644227,35.726801});
		coordinate.put("天水", new Double[]{105.736932,34.584319});
		coordinate.put("武威", new Double[]{102.640147,37.933172});
		coordinate.put("张掖", new Double[]{100.459892,38.93932});
		//广东省
		coordinate.put("潮州", new Double[]{116.630076,23.661812});
		coordinate.put("东莞", new Double[]{113.763434,23.043024});
		coordinate.put("广州", new Double[]{113.30765,23.120049});
		coordinate.put("河源", new Double[]{114.713721,23.757251});
		coordinate.put("惠州", new Double[]{114.410658,23.11354});
		coordinate.put("江门", new Double[]{113.078125,22.575117});
		coordinate.put("揭阳", new Double[]{116.379501,23.547999});
		coordinate.put("茂名", new Double[]{110.931245,21.668226});
		coordinate.put("梅州", new Double[]{116.126403,24.304571});
		coordinate.put("清远", new Double[]{113.040773,23.698469});
		coordinate.put("汕头", new Double[]{116.72865,23.383908});
		coordinate.put("汕尾", new Double[]{115.372924,22.778731});
		coordinate.put("韶关", new Double[]{113.594461,24.80296});
		coordinate.put("深圳", new Double[]{114.025974,22.546054});
		coordinate.put("阳江", new Double[]{111.97701,21.871517});
		coordinate.put("云浮", new Double[]{112.050946,22.937976});
		coordinate.put("湛江", new Double[]{110.365067,21.257463});
		coordinate.put("肇庆", new Double[]{112.479653,23.078663});
		coordinate.put("中山", new Double[]{113.42206,22.545178});
		coordinate.put("珠海", new Double[]{113.562447,22.256915});
		//广西省
		coordinate.put("百色", new Double[]{106.631821,23.901512});
		coordinate.put("北海", new Double[]{109.122628,21.472718});
		coordinate.put("崇左", new Double[]{107.357322,22.415455});
		coordinate.put("防城港", new Double[]{108.351791,21.617398});
		coordinate.put("桂林", new Double[]{110.26092,25.262901});
		coordinate.put("贵港", new Double[]{109.613708,23.103373});
		coordinate.put("河池", new Double[]{108.069948,24.699521});
		coordinate.put("贺州", new Double[]{111.552594,24.411054});
		coordinate.put("来宾", new Double[]{109.231817,23.741166});
		coordinate.put("柳州", new Double[]{109.422402,24.329053});
		coordinate.put("南宁", new Double[]{108.297234,22.806493});
		coordinate.put("钦州", new Double[]{108.638798,21.97335});
		coordinate.put("梧州", new Double[]{111.305472,23.485395});
		coordinate.put("玉林", new Double[]{110.151676,22.643974});
		//贵州省
		coordinate.put("安顺", new Double[]{105.92827,26.228595});
		coordinate.put("毕节", new Double[]{105.333323,27.408562});
		coordinate.put("贵阳", new Double[]{106.709177,26.629907});
		coordinate.put("六盘水", new Double[]{104.852087,26.591866});
		coordinate.put("黔东南苗族侗族自治州", new Double[]{107.985353,26.583992});
		coordinate.put("黔南布依族苗族自治州", new Double[]{107.523205,26.264536});
		coordinate.put("黔西南布依族苗族自治州", new Double[]{104.900558,25.095148});
		coordinate.put("铜仁", new Double[]{109.168558,27.674903});
		coordinate.put("遵义", new Double[]{106.93126,27.699961});
		//海南省
		coordinate.put("白沙黎族自治县", new Double[]{106.93126,27.699961});
		coordinate.put("保亭黎族苗族自治县", new Double[]{106.93126,27.699961});
		coordinate.put("昌江黎族自治县", new Double[]{106.93126,27.699961});
		coordinate.put("澄迈县", new Double[]{106.93126,27.699961});
		coordinate.put("定安县", new Double[]{106.93126,27.699961});
		coordinate.put("东方", new Double[]{106.93126,27.699961});
		coordinate.put("海口", new Double[]{110.330802,20.022071});
		coordinate.put("乐东黎族自治县", new Double[]{110.330802,20.022071});
		coordinate.put("临高县", new Double[]{110.330802,20.022071});
		coordinate.put("陵水黎族自治县", new Double[]{110.330802,20.022071});
		coordinate.put("琼海", new Double[]{110.330802,20.022071});
		coordinate.put("琼中黎族苗族自治县", new Double[]{110.330802,20.022071});
		coordinate.put("三亚", new Double[]{109.522771,18.257776});
		coordinate.put("屯昌县", new Double[]{109.522771,18.257776});
		coordinate.put("万宁", new Double[]{109.522771,18.257776});
		coordinate.put("文昌", new Double[]{109.522771,18.257776});
		coordinate.put("五指山", new Double[]{109.522771,18.257776});
		coordinate.put("儋州", new Double[]{109.522771,18.257776});
        //河北省
		coordinate.put("保定", new Double[]{115.49481,38.886565});
		coordinate.put("沧州", new Double[]{116.863806,38.297615});
		coordinate.put("承德", new Double[]{117.933822,40.992521});
		coordinate.put("邯郸", new Double[]{114.482694,36.609308});
		coordinate.put("衡水", new Double[]{115.686229,37.746929});
		coordinate.put("廊坊", new Double[]{116.703602,39.518611});
		coordinate.put("秦皇岛", new Double[]{119.604368,39.945462});
		coordinate.put("石家庄", new Double[]{114.522082,38.048958});
		coordinate.put("唐山", new Double[]{118.183451,39.650531});
		coordinate.put("邢台", new Double[]{114.520487,37.069531});
		coordinate.put("张家口", new Double[]{114.893782,40.811188});
		//河南省
		coordinate.put("安阳", new Double[]{114.351807,36.110267});
		coordinate.put("鹤壁", new Double[]{114.29777,35.755426});
		coordinate.put("焦作", new Double[]{113.211836,35.234608});
		coordinate.put("开封", new Double[]{114.351642,34.801854});
		coordinate.put("洛阳", new Double[]{112.447525,34.657368});
		coordinate.put("南阳", new Double[]{112.542842,33.01142});
		coordinate.put("平顶山", new Double[]{113.300849,33.745301});
		coordinate.put("三门峡", new Double[]{111.181262,34.78332});
		coordinate.put("商丘", new Double[]{115.641886,34.438589});
		coordinate.put("新乡", new Double[]{113.91269,35.307258});
		coordinate.put("信阳", new Double[]{114.085491,32.128582});
		coordinate.put("许昌", new Double[]{113.835312,34.02674});
		coordinate.put("郑州", new Double[]{113.649644,34.75661});
		coordinate.put("周口", new Double[]{114.654102,33.623741});
		coordinate.put("驻马店", new Double[]{114.049154,32.983158});
		coordinate.put("漯河", new Double[]{114.046061,33.576279});
		coordinate.put("濮阳", new Double[]{115.026627,35.753298});
		//黑龙江
		coordinate.put("大庆", new Double[]{125.02184,46.596708});
		coordinate.put("大兴安岭", new Double[]{124.676406,51.756299});
		coordinate.put("哈尔滨", new Double[]{126.657717,45.773224});
		coordinate.put("鹤岗", new Double[]{130.292472,47.338667});
		coordinate.put("黑河", new Double[]{127.50083,50.250689});
		coordinate.put("鸡西", new Double[]{130.941767,45.32154});
		coordinate.put("佳木斯", new Double[]{130.284735,46.81378});
		coordinate.put("牡丹江", new Double[]{129.608035,44.588521});
		coordinate.put("七台河", new Double[]{131.019048,45.775004});
		coordinate.put("齐齐哈尔", new Double[]{123.987289,47.347701});
		coordinate.put("双鸭山", new Double[]{131.171402,46.655102});
		coordinate.put("绥化", new Double[]{126.989095,46.646064});
		coordinate.put("伊春", new Double[]{128.910766,47.734686});
		//湖北省
		coordinate.put("鄂州", new Double[]{114.895594,30.384439});
		coordinate.put("恩施土家族苗族自治州", new Double[]{109.491923,30.285888});
		coordinate.put("黄冈", new Double[]{114.906618,30.446109});
		coordinate.put("黄石", new Double[]{115.050683,30.216127});
		coordinate.put("荆门", new Double[]{112.21733,31.042611});
		coordinate.put("荆州", new Double[]{112.241866,30.332591});
		coordinate.put("潜江", new Double[]{112.241866,30.332591});
		coordinate.put("神农架林区", new Double[]{112.241866,30.332591});
		coordinate.put("十堰", new Double[]{110.801229,32.636994});
		coordinate.put("随州", new Double[]{113.379358,31.717858});
		coordinate.put("天门", new Double[]{110.801229,32.636994});
		coordinate.put("武汉", new Double[]{114.3162,30.581084});
		coordinate.put("仙桃", new Double[]{114.3162,30.581084});
		coordinate.put("咸宁", new Double[]{114.300061,29.880657});
		coordinate.put("襄樊", new Double[]{112.176326,32.094934});
		coordinate.put("孝感", new Double[]{113.935734,30.927955});
		coordinate.put("宜昌", new Double[]{111.310981,30.732758});
		//湖南省
		coordinate.put("常德", new Double[]{111.653718,29.012149});
		coordinate.put("长沙", new Double[]{112.979353,28.213478});
		coordinate.put("郴州", new Double[]{113.037704,25.782264});
		coordinate.put("衡阳", new Double[]{112.583819,26.898164});
		coordinate.put("怀化", new Double[]{109.986959,27.557483});
		coordinate.put("娄底", new Double[]{111.996396,27.741073});
		coordinate.put("邵阳", new Double[]{111.461525,27.236811});
		coordinate.put("湘潭", new Double[]{112.935556,27.835095});
		coordinate.put("湘西土家族苗族自治州", new Double[]{109.745746,28.317951});
		coordinate.put("益阳", new Double[]{112.366547,28.588088});
		coordinate.put("岳阳", new Double[]{113.146196,29.378007});
		coordinate.put("张家界", new Double[]{110.48162,29.124889});
		coordinate.put("株洲", new Double[]{113.131695,27.827433});
		//吉林省
		coordinate.put("白城", new Double[]{122.840777,45.621085});
		coordinate.put("白山", new Double[]{126.435798,41.945859});
		coordinate.put("长春", new Double[]{125.313642,43.898338});
		coordinate.put("吉林", new Double[]{126.564544,43.871988});
		coordinate.put("辽源", new Double[]{125.133686,42.923303});
		coordinate.put("四平", new Double[]{124.391382,43.175525});
		coordinate.put("松原", new Double[]{124.832995,45.13605});
		coordinate.put("通化", new Double[]{125.94265,41.736397});
		coordinate.put("延边朝鲜族自治州", new Double[]{129.485902,42.896414});
		//江苏省
		coordinate.put("常州", new Double[]{119.981861,31.771397});
		coordinate.put("淮安", new Double[]{119.030186,33.606513});
		coordinate.put("连云港", new Double[]{119.173872,34.601549});
		coordinate.put("南京", new Double[]{118.778074,32.057236});
		coordinate.put("南通", new Double[]{120.873801,32.014665});
		coordinate.put("苏州", new Double[]{120.619907,31.317987});
		coordinate.put("宿迁", new Double[]{118.296893,33.95205});
		coordinate.put("泰州", new Double[]{119.919606,32.476053});
		coordinate.put("无锡", new Double[]{120.305456,31.570037});
		coordinate.put("徐州", new Double[]{117.188107,34.271553});
		coordinate.put("盐城", new Double[]{120.148872,33.379862});
		coordinate.put("扬州", new Double[]{119.427778,32.408505});
		coordinate.put("镇江", new Double[]{119.455835,32.204409});
		//江西省
		coordinate.put("抚州", new Double[]{116.360919,27.954545});
		coordinate.put("赣州", new Double[]{114.935909,25.845296});
		coordinate.put("吉安", new Double[]{114.992039,27.113848});
		coordinate.put("景德镇", new Double[]{117.186523,29.303563});
		coordinate.put("九江", new Double[]{115.999848,29.71964});
		coordinate.put("南昌", new Double[]{115.893528,28.689578});
		coordinate.put("萍乡", new Double[]{113.859917,27.639544});
		coordinate.put("上饶", new Double[]{117.955464,28.457623});
		coordinate.put("宜春", new Double[]{114.400039,27.81113});
		coordinate.put("鹰潭", new Double[]{117.03545,28.24131});
		//辽宁省
		coordinate.put("鞍山", new Double[]{123.007763,41.118744});
		coordinate.put("本溪", new Double[]{123.778062,41.325838});
		coordinate.put("朝阳", new Double[]{120.446163,41.571828});
		coordinate.put("大连", new Double[]{121.593478,38.94871});
		coordinate.put("丹东", new Double[]{124.338543,40.129023});
		coordinate.put("抚顺", new Double[]{123.92982,41.877304});
		coordinate.put("阜新", new Double[]{121.660822,42.01925});
		coordinate.put("葫芦岛", new Double[]{120.860758,40.74303});
		coordinate.put("锦州", new Double[]{121.147749,41.130879});
		coordinate.put("辽阳", new Double[]{123.172451,41.273339});
		coordinate.put("盘锦", new Double[]{122.073228,41.141248});
		coordinate.put("沈阳", new Double[]{123.432791,41.808645});
		coordinate.put("铁岭", new Double[]{123.85485,42.299757});
		coordinate.put("营口", new Double[]{122.233391,40.668651});
		//内蒙古
		coordinate.put("阿拉善盟", new Double[]{105.695683,38.843075});
		coordinate.put("巴彦淖尔盟", new Double[]{107.401345,40.68442});
		coordinate.put("包头", new Double[]{109.846239,40.647119});
		coordinate.put("赤峰", new Double[]{118.930761,42.297112});
		coordinate.put("鄂尔多斯", new Double[]{109.993706,39.81649});
		coordinate.put("呼和浩特", new Double[]{111.660351,40.828319});
		coordinate.put("呼伦贝尔", new Double[]{119.760822,49.201636});
		coordinate.put("通辽", new Double[]{122.260363,43.633756});
		coordinate.put("乌海", new Double[]{106.831999,39.683177});
		coordinate.put("乌兰察布盟", new Double[]{113.120604,41.001299});
		coordinate.put("锡林郭勒盟", new Double[]{116.02734,43.939705});
		coordinate.put("兴安盟", new Double[]{122.048167,46.083756});
		//宁夏
		coordinate.put("固原", new Double[]{106.285268,36.021523});
		coordinate.put("石嘴山", new Double[]{106.379337,39.020223});
		coordinate.put("吴忠", new Double[]{106.208254,37.993561});
		coordinate.put("银川", new Double[]{106.206479,38.502621});
		//青海
		coordinate.put("果洛藏族自治州", new Double[]{100.223723,34.480485});
		coordinate.put("海北藏族自治州", new Double[]{100.879802,36.960654});
		coordinate.put("海东", new Double[]{102.110571,49.201636});
		coordinate.put("海南藏族自治州", new Double[]{100.624066,36.284364});
		coordinate.put("海西蒙古族藏族自治州", new Double[]{97.342625,37.373799});
		coordinate.put("黄南藏族自治州", new Double[]{102.0076,35.522852});
		coordinate.put("西宁", new Double[]{101.767921,36.640739});
		coordinate.put("玉树藏族自治州", new Double[]{97.013316,33.00624});
		//山东省
		coordinate.put("滨州", new Double[]{117.968292,37.405314});
		coordinate.put("德州", new Double[]{116.328161,37.460826});
		coordinate.put("东营", new Double[]{118.583926,37.487121});
		coordinate.put("济南", new Double[]{117.024967,36.682785});
		coordinate.put("济宁", new Double[]{116.600798,35.402122});
		coordinate.put("莱芜", new Double[]{117.684667,36.233654});
		coordinate.put("聊城", new Double[]{115.986869,36.455829});
		coordinate.put("临沂", new Double[]{118.340768,35.072409});
		coordinate.put("青岛", new Double[]{120.384428,36.105215});
		coordinate.put("日照", new Double[]{119.50718,35.420225});
		coordinate.put("泰安", new Double[]{117.089415,36.188078});
		coordinate.put("威海", new Double[]{122.093958,37.528787});
		coordinate.put("潍坊", new Double[]{119.142634,36.716115});
		coordinate.put("烟台", new Double[]{121.309555,37.536562});
		coordinate.put("枣庄", new Double[]{117.279305,34.807883});
		coordinate.put("淄博", new Double[]{118.059134,36.804685});
		//山西省
		coordinate.put("长治", new Double[]{113.120292,36.201664});
		coordinate.put("大同", new Double[]{113.290509,40.113744});
		coordinate.put("晋城", new Double[]{112.867333,35.499834});
		coordinate.put("晋中", new Double[]{112.738514,37.693362});
		coordinate.put("临汾", new Double[]{111.538788,36.099745});
		coordinate.put("吕梁", new Double[]{111.143157,37.527316});
		coordinate.put("朔州", new Double[]{112.479928,39.337672});
		coordinate.put("太原", new Double[]{112.550864,37.890277});
		coordinate.put("忻州", new Double[]{112.727939,38.461031});
		coordinate.put("阳泉", new Double[]{113.569238,37.869529});
		coordinate.put("运城", new Double[]{111.006854,35.038859});
		//陕西省
		coordinate.put("安康", new Double[]{109.038045,32.70437});
		coordinate.put("宝鸡", new Double[]{107.170645,34.364081});
		coordinate.put("汉中", new Double[]{107.045478,33.081569});
		coordinate.put("商洛", new Double[]{109.934208,33.873907});
		coordinate.put("铜川", new Double[]{108.968067,34.908368});
		coordinate.put("渭南", new Double[]{109.483933,34.502358});
		coordinate.put("西安", new Double[]{108.953098,34.2778});
		coordinate.put("咸阳", new Double[]{108.707509,34.345373});
		coordinate.put("延安", new Double[]{109.50051,36.60332});
		coordinate.put("榆林", new Double[]{109.745926,38.279439});
	    //四川省
		coordinate.put("阿坝藏族羌族自治州", new Double[]{102.228565,31.905763});
		coordinate.put("巴中", new Double[]{106.757916,31.869189});
		coordinate.put("成都", new Double[]{104.067923,30.679943});
		coordinate.put("达州", new Double[]{107.494973,31.214199});
		coordinate.put("德阳", new Double[]{104.402398,31.13114});
		coordinate.put("甘孜藏族自治州", new Double[]{101.969232,30.055144});
		coordinate.put("广安", new Double[]{106.63572,30.463984});
		coordinate.put("广元", new Double[]{105.819687,32.44104});
		coordinate.put("凉山彝族自治州", new Double[]{102.259591,27.892393});
		coordinate.put("眉山", new Double[]{103.84143,30.061115});
		coordinate.put("绵阳", new Double[]{104.705519,31.504701});
		coordinate.put("南充", new Double[]{106.105554,30.800965});
		coordinate.put("内江", new Double[]{105.073056,29.599462});
		coordinate.put("攀枝花", new Double[]{101.722423,26.587571});
		coordinate.put("遂宁", new Double[]{105.564888,30.557491});
		coordinate.put("雅安", new Double[]{103.009356,29.999716});
		coordinate.put("宜宾", new Double[]{104.633019,28.769675});
		coordinate.put("资阳", new Double[]{104.63593,30.132191});
		coordinate.put("自贡", new Double[]{104.776071,29.359157});
		coordinate.put("泸州", new Double[]{105.44397,28.89593});
	    //天津
		coordinate.put("天津", new Double[]{117.210813,39.14393});
		//西藏
		coordinate.put("阿里", new Double[]{81.189395,30.384675});
		coordinate.put("昌都", new Double[]{97.244052,31.44848});
		coordinate.put("拉萨", new Double[]{91.111891,29.662557});
		coordinate.put("林芝", new Double[]{94.380416,29.783256});
		coordinate.put("那曲", new Double[]{92.034626,31.252315});
		coordinate.put("日喀则", new Double[]{88.956063,29.26816});
		coordinate.put("山南", new Double[]{91.750644,29.229027});
		//新疆
		coordinate.put("阿克苏", new Double[]{81.156013,40.349444});
		coordinate.put("阿拉尔", new Double[]{81.156013,40.349444});
		coordinate.put("巴音郭楞蒙古自治州", new Double[]{86.121688,41.771362});
		coordinate.put("博尔塔拉蒙古自治州", new Double[]{82.052436,44.913651});
		coordinate.put("昌吉回族自治州", new Double[]{87.296038,44.007058});
		coordinate.put("哈密", new Double[]{93.529373,42.344467});
		coordinate.put("和田", new Double[]{79.915814,37.15335});
		coordinate.put("喀什", new Double[]{76.014343,39.513111});
		coordinate.put("克拉玛依", new Double[]{84.88118,45.59433});
		coordinate.put("克孜勒苏柯尔克孜自治州", new Double[]{76.137564,39.750346});
		coordinate.put("石河子", new Double[]{76.137564,39.750346});
		coordinate.put("图木舒克", new Double[]{76.137564,39.750346});
		coordinate.put("吐鲁番", new Double[]{89.266025,42.678925});
		coordinate.put("乌鲁木齐", new Double[]{87.564988,43.84038});
		coordinate.put("五家渠", new Double[]{87.564988,43.84038});
		coordinate.put("伊犁哈萨克自治州", new Double[]{81.297854,43.922248});
		//云南
		coordinate.put("保山", new Double[]{99.177996,25.120489});
		coordinate.put("楚雄彝族自治州", new Double[]{101.529382,25.066356});
		coordinate.put("大理白族自治州", new Double[]{100.223675,25.5969});
		coordinate.put("德宏傣族景颇族自治州", new Double[]{98.589434,24.44124});
		coordinate.put("迪庆藏族自治州", new Double[]{99.713682,27.831029});
		coordinate.put("红河哈尼族彝族自治州", new Double[]{103.384065,23.367718});
		coordinate.put("昆明", new Double[]{102.714601,25.049153});
		coordinate.put("丽江", new Double[]{100.229628,26.875351});
		coordinate.put("临沧", new Double[]{100.092613,23.887806});
		coordinate.put("怒江傈傈族自治州", new Double[]{98.970382,25.801859});
		coordinate.put("曲靖", new Double[]{103.782539,25.520758});
		coordinate.put("思茅", new Double[]{100.983364,22.791577});
		coordinate.put("文山壮族苗族自治州", new Double[]{104.246294,23.374087});
		coordinate.put("西双版纳傣族自治州", new Double[]{100.803038,22.009433});
		coordinate.put("玉溪", new Double[]{102.545068,24.370447});
		coordinate.put("昭通", new Double[]{103.725021,27.340633});
		///浙江省
		coordinate.put("杭州", new Double[]{120.219375,30.259244});
		coordinate.put("湖州", new Double[]{120.137243,30.877925});
		coordinate.put("嘉兴", new Double[]{120.760428,30.773992});
		coordinate.put("金华", new Double[]{119.652576,29.102899});
		coordinate.put("丽水", new Double[]{119.929576,28.4563});
		coordinate.put("宁波", new Double[]{121.579006,29.885259});
		coordinate.put("绍兴", new Double[]{120.592467,30.002365});
		coordinate.put("台州", new Double[]{121.440613,28.668283});
		coordinate.put("温州", new Double[]{120.690635,28.002838});
		coordinate.put("舟山", new Double[]{122.169872,30.03601});
		coordinate.put("衢州", new Double[]{118.875842,28.95691});
	    //重庆
		coordinate.put("重庆", new Double[]{106.530635,29.544606});
		
		coordinate.put("北京", new Double[]{116.395645,39.929986});
		coordinate.put("上海", new Double[]{116.395645,39.929986});
	}
	public static Double[] getCoordinate(String city){
		if(null==coordinate){
			initCoordinate();
		}
		return coordinate.get(city); 
	}
}