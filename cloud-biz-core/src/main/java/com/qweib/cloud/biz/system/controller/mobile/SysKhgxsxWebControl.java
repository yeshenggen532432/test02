package com.qweib.cloud.biz.system.controller.mobile;


import com.google.common.collect.Lists;
import com.qweib.cloud.biz.system.BaseWebService;
import com.qweib.cloud.biz.system.TokenServer;
import com.qweib.cloud.biz.system.service.SysCustomerHzfsService;
import com.qweib.cloud.biz.system.service.SysKhgxsxService;
import com.qweib.cloud.biz.system.service.SysXtcsService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping("/web")
public class SysKhgxsxWebControl extends BaseWebService {
    @Resource
    private SysKhgxsxService khgxsxService;
    @Resource
    private SysXtcsService xtcsService;

    @Resource
    private SysCustomerHzfsService customerHzfsService;

    /**
     * 说明：获取拜访频次列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryBfpcls")
    public void queryBfpcls(HttpServletResponse response) {
        try {
            List<SysBfpc> bfpcls = this.khgxsxService.queryBfpcls();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取拜访频次列表成功");
            json.put("bfpcls", bfpcls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取拜访频次列表失败");
        }
    }

    /**
     * 说明：获取供货类型列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryGhtypels")
    public void queryGhtypels(HttpServletResponse response) {
        try {
            List<SysGhtype> ghtypels = this.khgxsxService.queryGhtypels();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取供货类型列表成功");
            json.put("ghtypels", ghtypels);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取供货类型列表失败");
        }
    }

    /**
     * 说明：获取经销商分类列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryJxsflls")
    public void queryJxsflls(HttpServletResponse response, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }
            List<SysJxsfl> jxsflls = this.khgxsxService.queryJxsflls(Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取经销商分类列表成功");
            json.put("jxsflls", jxsflls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取经销商分类列表失败");
        }
    }

    /**
     * 说明：获取经销商级别列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryJxsjbls")
    public void queryJxsjbls(HttpServletResponse response, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }
            List<SysJxsjb> jxsjbls = this.khgxsxService.queryJxsjbls(Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取经销商级别列表成功");
            json.put("jxsjbls", jxsjbls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取经销商级别列表失败");
        }
    }

    /**
     * 说明：获取经销商状态列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryJxsztls")
    public void queryJxsztls(HttpServletResponse response, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }
            List<SysJxszt> jxsztls = this.khgxsxService.queryJxsztls(Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取经销商状态列表成功");
            json.put("jxsztls", jxsztls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取经销商状态列表失败");
        }
    }

    /**
     * 说明：获取客户等级列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryKhlevells")
    public void queryKhlevells(HttpServletResponse response, Integer qdId, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }

            List<SysKhlevel> khlevells = this.khgxsxService.queryKhlevells(qdId, Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取客户等级列表成功");
            json.put("khlevells", khlevells);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取客户等级列表失败");
        }
    }

    /**
     * 说明：获取渠道类型列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryQdtypls")
    public void queryQdtypls(HttpServletResponse response, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }
            List<SysQdtype> qdtypels = this.khgxsxService.queryQdtypls(Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取渠道类型列表成功");
            json.put("qdtypels", qdtypels);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取渠道类型列表失败");
        }
    }

    /**
     * 说明：获取客户类型及级别列表
     *
     * @创建：作者:llp 创建时间：2016-7-29
     * @修改历史： [序号](llp 2016 - 7 - 29)<修改说明>
     */
    @RequestMapping("queryKhFlJbls")
    public void queryKhFlJbls(HttpServletResponse response, String token) {
        try {
            String Database = "sjk1460427117375139";
            if (!StrUtil.isNull(token)) {
                OnlineMessage message = TokenServer.tokenCheck(token);
                if (message.isSuccess() == false) {
                    sendWarm(response, message.getMessage());
                    return;
                }
                OnlineUser onlineUser = message.getOnlineMember();
                Database = onlineUser.getDatabase();
            }
            List<SysQdtype> qdtypels = this.khgxsxService.queryQdtypls(Database);
            List<SysKhlevel> khlevells = this.khgxsxService.queryKhlevells(null, Database);
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取客户类型及级别列表成功");
            json.put("qdtypels", qdtypels);
            json.put("khlevells", khlevells);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取客户类型及级别列表失败");
        }
    }

    /**
     * 说明：获取市场类型列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("querySctypels")
    public void querySctypels(HttpServletResponse response) {
        try {
            List<SysSctype> sctypels = this.khgxsxService.querySctypels();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取市场类型列表成功");
            json.put("sctypels", sctypels);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取市场类型列表失败");
        }
    }

    /**
     * 说明：获取销售阶段列表
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryXsphasels")
    public void queryXsphasels(HttpServletResponse response) {
        try {
            List<SysXsphase> xsphasels = this.khgxsxService.queryXsphasels();
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取销售阶段列表成功");
            json.put("xsphasels", xsphasels);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取销售阶段列表失败");
        }
    }

    /**
     * 说明：列表查询合作方式
     *
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    @RequestMapping("queryHzfsls")
    public void queryHzfsls(HttpServletResponse response, String token) {
        try {
            if (!checkParam(response, token))
                return;
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            OnlineUser onlineUser = message.getOnlineMember();
            List<SysCustomerHzfs> hzfsls = this.customerHzfsService.queryHzfsList(onlineUser.getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取合作方式列表成功");
            json.put("hzfsls", hzfsls);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取合作方式列表失败");
        }
    }

    /**
     * 说明：列表查询销售类型
     *
     * @创建：作者:llp 创建时间：2016-4-13
     * @修改历史： [序号](llp 2016 - 4 - 13)<修改说明>
     */
    @RequestMapping("queryXstypels")
    public void queryXstypels(HttpServletResponse response) {
        try {
            //TODO
            //List<SysXstype> xstypels = this.khgxsxService.queryXstypels();
            List<SysXstype> xstypels = Lists.newArrayList(
                    new SysXstype(1,"正常销售"),
                    new SysXstype(2,"促销折让"),
                    new SysXstype(3,"消费折让"),
                    new SysXstype(4,"费用折让"),
                    new SysXstype(5,"其他销售")
            );
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取销售类型列表成功");
            json.put("xstypels", xstypels);
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取销售类型列表失败");
        }
    }

    /**
     * 说明：获取系统参数1
     *
     * @创建：作者:llp 创建时间：2016-2-19
     * @修改历史： [序号](llp 2016 - 2 - 19)<修改说明>
     */
    @RequestMapping("queryXtcsWeb1")
    public void queryXtcsWeb1(HttpServletResponse response, String token) {
        try {
            OnlineMessage message = TokenServer.tokenCheck(token);
            if (message.isSuccess() == false) {
                sendWarm(response, message.getMessage());
                return;
            }
            SysXtcs xtcs = this.xtcsService.queryXtcsById(1, message.getOnlineMember().getDatabase());
            JSONObject json = new JSONObject();
            json.put("state", true);
            json.put("msg", "获取系统参数成功");
            json.put("xtCsz", xtcs.getXtCsz());
            this.sendJsonResponse(response, json.toString());
        } catch (Exception e) {
            this.sendWarm(response, "获取系统参数失败");
        }
    }
}
