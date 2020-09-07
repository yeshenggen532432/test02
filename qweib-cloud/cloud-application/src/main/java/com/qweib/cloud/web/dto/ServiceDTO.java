package com.qweib.cloud.web.dto;

import com.qweib.im.api.dto.Service;
import lombok.Data;

/**
 * @author jimmy.lin
 * create at 2020/2/17 7:38
 */
@Data
public class ServiceDTO extends Service {
    private String branchName;
}
