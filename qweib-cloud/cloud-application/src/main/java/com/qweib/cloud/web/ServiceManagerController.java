package com.qweib.cloud.web;

import com.qweibframework.commons.web.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author jimmy.lin
 * create at 2020/2/17 3:13
 */
@Controller
@RequestMapping("manager/service")
public class ServiceManagerController extends BaseController {

    @GetMapping("index")
    public String index(){
        return "im/service";
    }

}
