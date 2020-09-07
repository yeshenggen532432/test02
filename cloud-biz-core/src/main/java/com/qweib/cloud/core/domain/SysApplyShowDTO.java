package com.qweib.cloud.core.domain;


import lombok.Data;

import java.util.List;

/**
 * 移动端应用表
 *
 * @author Administrator
 */
@Data
public class SysApplyShowDTO extends SysApplyDTO {

    private List<SysApplyShowDTO> children;
}
