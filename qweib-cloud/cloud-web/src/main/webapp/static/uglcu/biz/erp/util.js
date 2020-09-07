/**
 * 验证进销存表单数据符号是否一样
 * @param datas
 * @param ioMark
 */
function checkFormQtySign(datas,ioMark){
     var bool = true;
     var msg = "";
     for(var i=0;i<datas.length;i++){
         var data = datas[i];
         if(ioMark==1){
             if(data.qty&&data.qty<0){
                msg = "数量列必须大于0";
                bool = false;
                break;
             }
             if(data.outQty1&&data.outQty1<0){
                 msg = "数量列必须大于0";
                 bool = false;
                 break;
             }

             if(data.inQty1&&data.inQty1<0){
                 msg = "数据列必须大于0";
                 bool = false;
                 break;
             }
         }
         if(ioMark==-1){
             if(data.qty&&data.qty>0){
                msg = "红字单,数量列必须都小于0";
                bool = false;
                break
             }
             if(data.outQty1&&data.outQty1>0){
                 msg = "红字单,数量列必须都小于0";
                 bool = false;
                 break
             }
             if(data.inQty1&&data.inQty1>0){
                 msg = "红字单,数据列必须小于0";
                 bool = false;
                 break;
             }
         }
     }
        if(!bool){
          uglcw.ui.error(msg);
        }
     return bool;
}