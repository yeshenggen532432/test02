var pfFieldObj = {
    rate: "shopWareRate",
    maxFild: "shopWarePrice",
    maxFildTemp: "shopWarePriceTemp",
    smallFild: "shopWareSmallPrice",
    smallFildTemp: "shopWareSmallPriceTemp"
};

var lsFieldObj = {
    rate: "shopWareLsRate",
    maxFild: "shopWareLsPrice",
    maxFildTemp: "shopWareLsPriceTemp",
    smallFild: "shopWareSmallLsPrice",
    smallFildTemp: "shopWareSmallLsPriceTemp"
};
//换算比较修改时
function chageRate(value, field, model) {
    if (value == 0) {
        uglcw.ui.error('不能为0');
        return false;
    }
    var basePfRate = getRate.ls();
    var obj = lsFieldObj;
    if (pfFieldObj.rate == field) {
        obj = pfFieldObj;
        basePfRate = getRate.pf();
    }

    var maxPrice = null;
    if (value) {
        if (model.lsPrice) {
            maxPrice = (model.lsPrice * (value / 100)).toFixed(2);//大单位价格=原价*当前系数/100
            changeTemp(obj.maxFildTemp, null, model)

            if (!model[obj.smallFild]) {//如果小单位未设置时
                changeTemp(obj.smallFildTemp, (maxPrice / model.hsNum), model);//小单位零时价格=大单位价格/大小单位换算比例
            }
        } else {
            uglcw.ui.error('原价(进)不能为空');
            return false;
        }
    } else {
        if (model.lsPrice && basePfRate) {//原价和全局换算比例不为空时
            var maxPriceTemp = (model.lsPrice * basePfRate / 100).toFixed(2);
            changeTemp(obj.maxFildTemp, maxPriceTemp, model)
            if (!model[obj.smallFild]) {
                changeTemp(obj.smallFildTemp, (maxPriceTemp / model.hsNum), model);//小单位价格=大单位价格/批发系数
            }
        } else {
            if (!model[obj.smallFild])
                changeTemp(obj.smallFildTemp, null, model);
            else {
                changeTemp(obj.maxFildTemp, model[obj.smallFild] * model.hsNum, model);
            }
        }
    }
    model.set(obj.maxFild, maxPrice);//修改大单位价格
    changePrice2(value, field, model.wareId, function () {
        changePrice2(model[obj.maxFild], obj.maxFild, model.wareId);
    });
}


function changeMaxPrice(value, field, model) {
    if (value == 0) {
        uglcw.ui.error('大单位金额不能为0');
        return false;
    }
    var basePfRate = getRate.ls();
    var obj = lsFieldObj;
    if (pfFieldObj.maxFild == field) {
        obj = pfFieldObj;
        basePfRate = getRate.pf();
    }

    if (!value) {//为空时当前系数为空
        model.set(obj.rate, null);
    }

    if (value) {
        model.set(obj.maxFildTemp, null);
        if (model.lsPrice) {
            model.set(obj.rate, (value / model.lsPrice * 100).toFixed(2));
        }
        if (!model[obj.smallFild]) {//如果小单位未设置时
            changeTemp(obj.smallFildTemp, (value / model.hsNum), model);
        }
    } else {
        if (model.lsPrice && basePfRate && !model[obj.smallFild]) {
            var maxPriceTemp = (model.lsPrice * (basePfRate / 100)).toFixed(2);
            model.set(obj.maxFildTemp, maxPriceTemp);
            changeTemp(obj.smallFildTemp, (maxPriceTemp / model.hsNum), model);
        } else {
            if (model[obj.smallFild]) {
                changeTemp(obj.maxFildTemp, (model[obj.smallFild] * model.hsNum), model);
            } else {
                changeTemp(obj.smallFildTemp, null, model);
            }
        }
    }
    changePrice2(value, field, model.wareId, function () {
        changePrice2(model[obj.rate], obj.rate, model.wareId);
    });
}

//小单位修改
function chageSmallPrice(value, field, model) {
    var basePfRate = getRate.ls();
    var obj = lsFieldObj;
    if (pfFieldObj.smallFild == field) {
        obj = pfFieldObj;
        basePfRate = getRate.pf();
    }
    model.set(obj.smallFildTemp, null);
    if (value) {
        if (!model[obj.maxFild]) {
            changeTemp(obj.maxFildTemp, (value * model.hsNum), model);
        }
    } else {//批发价小为空时
        if (model.lsPrice && basePfRate && !model[obj.maxFild]) {
            if (!model[obj.maxFild]) {
                changeTemp(obj.maxFildTemp, (model.lsPrice * (basePfRate / 100)), model);
                changeTemp(obj.smallFildTemp, (model[obj.maxFildTemp] / model.hsNum), model);
            } else {
                changeTemp(obj.smallFildTemp, (model[obj.maxFild] / model.hsNum), model);
            }
        } else {
            if (model[obj.maxFild]) {
                changeTemp(obj.smallFildTemp, (model[obj.maxFild] / model.hsNum), model);
            } else {
                changeTemp(obj.maxFildTemp, null, model);
            }
        }
    }
    changePrice2(value, field, model.wareId);
}
function changeTemp(tempField, value, model) {
    value = value ? parseFloat(value).toFixed(2) : null;
    model.set(tempField, value);
    var orignField = tempField.replace('Temp', '');
    model.set(orignField, 1);
    model.set(orignField, null);
}

function changePrice2(value, field, wareId, fun) {
    $.ajax({
        url: chagePriceUrl,
        type: "post",
        data: {
            wareId: wareId,
            field: field,
            price: value
        },
        success: function (data) {
            if (data == '1') {
                if (fun) fun();
                else
                    uglcw.ui.success('修改成功');
                return true;
            } else {
                uglcw.ui.toast("价格保存失败");
            }
        }
    });
}