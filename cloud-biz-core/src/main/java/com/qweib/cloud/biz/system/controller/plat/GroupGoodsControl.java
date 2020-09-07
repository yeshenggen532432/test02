package com.qweib.cloud.biz.system.controller.plat;


import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.plat.GroupGoodsService;
import com.qweib.cloud.core.domain.ArrayGpDetail;
import com.qweib.cloud.core.domain.GroupGoods;
import com.qweib.cloud.core.domain.GroupGoodsDetail;
import com.qweib.cloud.utils.ImageUtil;
import com.qweib.cloud.utils.ImgCoordinate;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class GroupGoodsControl extends GeneralControl {
    @Resource
    private GroupGoodsService groupGoodsService;

    /**
     * ժҪ��
     *
     * @param @return
     * @˵������Ʒ��ҳ
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("/queryGroupGoods")
    public String queryGroupGoods() {
        return "/publicplat/groupgoods/groupgoods";
    }

    /**
     * ժҪ��
     *
     * @param @param request
     * @param @param response
     * @param @param groupgoods
     * @param @param page
     * @param @param rows
     * @˵������ҳ��ѯ��Ʒ
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("/groupgoodsPage")
    public void groupgoodsPage(HttpServletRequest request, HttpServletResponse response, GroupGoods groupgoods, Integer page, Integer rows) {
        try {
            Page p = this.groupGoodsService.queryGroupGoods(groupgoods, page, rows);
            JSONObject json = new JSONObject();
            json.put("total", p.getTotal());
            json.put("rows", p.getRows());
            this.sendJsonResponse(response, json.toString());
            p = null;
        } catch (Exception e) {
            log.error("��ҳ��ѯ��Ʒ����", e);
        }
    }

    /**
     * @param Id
     * @˵�������/�޸���Ʒҳ��
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("toopergroupgoods")
    public String toopergroupgoods(Model model, Integer Id) {
        if (null != Id) {
            try {
                GroupGoods groupgoods = this.groupGoodsService.queryGroupGoodsById(Id);
                model.addAttribute("groupgoods", groupgoods);
                List<GroupGoodsDetail> details = this.groupGoodsService.queryGroupGoodsDetail(Id);
                model.addAttribute("details", details);
                model.addAttribute("detailCount", details.size());
            } catch (Exception e) {
                log.error("��ȡ��Ʒ��Ϣ����", e);
                model.addAttribute("detailCount", 1);
            }
        } else {
            model.addAttribute("detailCount", 1);
        }
        return "/publicplat/groupgoods/groupgoodsoper";
    }

    /**
     * @param groupgoods
     * @˵�������/�޸���Ʒ
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("opergroupgoods")
    public void opergroupgoods(HttpServletResponse response, HttpServletRequest request, GroupGoods groupgoods, ArrayGpDetail gpDetails) {
        try {
            //��Ƭ·��
            String path = request.getSession().getServletContext().getRealPath("/upload");
            //��Ƭ
            String photo = groupgoods.getPic();
            if (null == groupgoods.getId()) {
                //�ļ�Ŀ¼
                String folderPath = path + "/groupgoods";
                String folderPath1 = path + "/groupgoodsdetail";
                this.groupGoodsService.addGroupGoods(groupgoods, gpDetails.getGpDetails());
                //�ƶ�ͼƬ
                if (!StrUtil.isNull(photo)) {
                    StrUtil.renameFile(path + "/temp", photo, folderPath, photo);
                }
                List<GroupGoodsDetail> details = gpDetails.getGpDetails();
                for (GroupGoodsDetail detail : details) {
                    String detailPhoto = detail.getPic();
                    if (!StrUtil.isNull(detailPhoto)) {
                        StrUtil.renameFile(path + "/temp", detailPhoto, folderPath1, detailPhoto);
                    }
                }
                this.sendHtmlResponse(response, "1");
            } else {
                this.groupGoodsService.updateGroupGoods(groupgoods, gpDetails.getGpDetails());
                //�ļ�Ŀ¼
                String folderPath = path + "/groupgoods";
                String folderPath1 = path + "/groupgoodsdetail";
                //�ж�ͼƬ�Ƿ��иı�
                String oldPhoto = groupgoods.getOldpic();
                if (!photo.equals(oldPhoto)) {
                    StrUtil.renameFile(path + "/temp", photo, folderPath, photo);
                    File renameFile = new File(folderPath + "/" + oldPhoto);
                    if (renameFile.exists()) {
                        this.deletepic(new File(request.getSession().getServletContext().getRealPath("/upload/groupgoods")), oldPhoto);
                    }
                }
                List<GroupGoodsDetail> details = gpDetails.getGpDetails();
                for (GroupGoodsDetail detail : details) {
                    String detailOldPhoto = detail.getOldpic();
                    String detailPhoto = detail.getPic();
                    if ((null == detailOldPhoto && !StrUtil.isNull(detailPhoto)) || (null != detailOldPhoto && !detailOldPhoto.equals(detailPhoto))) {
                        StrUtil.renameFile(path + "/temp", detailPhoto, folderPath1, detailPhoto);
                        File renameFile = new File(folderPath1 + "/" + detailOldPhoto);
                        if (renameFile.exists()) {
                            this.deletepic(new File(request.getSession().getServletContext().getRealPath("/upload/groupgoodsdetail")), detailOldPhoto);
                        }
                    }
                }
                this.sendHtmlResponse(response, "2");
            }

        } catch (Exception e) {
            log.error("���/�޸���Ʒ����", e);
        }
    }

    /**
     * @param Id
     * @˵������Ʒ����ҳ��
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("groupgoodsxq")
    public String groupgoodsxq(Model model, Integer Id) {
        GroupGoods groupgoods = this.groupGoodsService.queryGroupGoodsById(Id);
        model.addAttribute("groupgoods", groupgoods);
        List<GroupGoodsDetail> details = this.groupGoodsService.queryGroupGoodsDetail(Id);
        model.addAttribute("details", details);
        return "/publicplat/groupgoods/groupgoodsxq";
    }

    /**
     * @param id
     * @˵��������ɾ����Ʒ
     * @����������:llp        ����ʱ�䣺2015-1-27
     * @�޸���ʷ�� [���](llp	2015-1-27)<�޸�˵��>
     */
    @RequestMapping("/delgroupgoods")
    public void delgroupgoods(Integer[] id, HttpServletResponse response, HttpServletRequest request) {
        try {
            for (int i = 0; i < id.length; i++) {
                GroupGoods groupgoods = this.groupGoodsService.queryGroupGoodsById(id[i]);
                List<GroupGoodsDetail> details = this.groupGoodsService.queryGroupGoodsDetail(id[i]);
                for (int j = 0; j < details.size(); j++) {
                    this.deletepic(new File(request.getSession().getServletContext().getRealPath("/upload/groupgoodsdetail")), details.get(j).getPic());
                }
                this.deletepic(new File(request.getSession().getServletContext().getRealPath("/upload/groupgoods")), groupgoods.getPic());
            }
            this.groupGoodsService.deleteGroupGoodsDetail(id);
            this.groupGoodsService.deleteGroupGoods(id);
            this.sendHtmlResponse(response, "1");
        } catch (Exception e) {
            log.error("ɾ����Ʒ����", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    //ɾ����Ƭ
    private void deletepic(File file, String photo) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            for (File file2 : files) {
                deletepic(file2, photo);
            }
        } else {
            String name = file.getName();
            if (photo.equals(name)) {
                file.delete();
            }

        }
    }

    /**
     * ժҪ��
     *
     * @return
     * @˵����ȥ�ϴ�ҳ��
     * @����������:yxy        ����ʱ�䣺2013-4-18
     * @�޸���ʷ�� [���](yxy	2013-4-18)<�޸�˵��>
     */
    @RequestMapping("/toupfile")
    public String toUpFile(Model model, int width, int height) {
        model.addAttribute("width", width);
        model.addAttribute("height", height);
        return "/include/upFile";
    }

    /**
     * ժҪ��
     *
     * @˵�����ϴ�����ʱ�ļ���
     * @����������:yxy        ����ʱ�䣺2013-4-18
     * @�޸���ʷ�� [���](yxy	2013-4-18)<�޸�˵��>
     */
    @RequestMapping("/uploadtemp")
    public void uploadTemp(HttpServletRequest request, HttpServletResponse response, int width, int height) {
        MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        MultipartFile upFile = multiRequest.getFile("upFile");
        //��Ƭ·��
        String path = request.getSession().getServletContext().getRealPath("/upload/temp");
        try {
            //�ϴ�ͼƬ
            String fileName = StrUtil.upLoadFile(upFile, path, null);
            BufferedImage sourceImg = ImageIO.read(new FileInputStream(path + "/" + fileName));
            int sourceWidth = sourceImg.getWidth();
            int sourceHeight = sourceImg.getHeight();
            if (sourceWidth < width || sourceHeight < height) {
                this.sendHtmlResponse(response, "-1");
                return;
            }
            if (StrUtil.isNull(fileName)) {
                this.sendHtmlResponse(response, "-2");
                return;
            }
            this.sendHtmlResponse(response, fileName);
        } catch (Exception e) {
            log.error("�ϴ�����ʱ�ļ��г���", e);
            this.sendHtmlResponse(response, "-2");
        }
    }

    /**
     * @param @return
     * @˵�����ϱ��ϴ�ͼƬ����
     * @����������:llp        ����ʱ�䣺2013-9-18
     * @�޸���ʷ�� [���](llp	2013--9-18)<�޸�˵��>
     */
    @RequestMapping("/groupgoodsToImgCoord")
    public String toImgCoord(Model model, String imgsrc) {
        model.addAttribute("imgsrc", imgsrc);
        return "/main/toImgCoord";
    }

    /**
     * ˵����ͼƬ����
     *
     * @param x      ��ʼ(������)
     * @param y      ��ʼ(������)
     * @param width  ���õĿ��
     * @param height ���õĸ߶�
     * @param folder Ҫ�����Ŀ¼
     * @param imgNm  Ҫ������ļ�����
     * @����������:llp ����ʱ�䣺2013-8-23
     * @�޸���ʷ�� [���](llp 2013-8-23)<�޸�˵��>
     */
    @RequestMapping("/imgCoordinate")
    public void imgCoordinate(ImgCoordinate imgc, HttpServletResponse response, HttpServletRequest request) {
        try {
            String path = request.getSession().getServletContext().getRealPath("/upload");
            String folder = path + "/temp";
            String fileName = imgc.getSrcpath();
            imgc.setSrcpath(folder + "/" + fileName);
            imgc.setFolder(folder);
            imgc.setImgNm("gp" + System.currentTimeMillis());
            String srcPath = folder + "/s" + fileName;
            //ͼƬ����
            ImageUtil.scImgBySize(imgc.getSrcpath(), srcPath, imgc.getImgWidth(), imgc.getImgHeight());
            imgc.setSrcpath(srcPath);
            //ͼƬ����
            String imgNm = ImageUtil.clipping(imgc);
            if (StrUtil.isNull(imgNm)) {
                this.sendHtmlResponse(response, "-1");
            } else {
                this.sendHtmlResponse(response, imgNm);
            }
        } catch (Exception e) {
            log.error("��ͼ����", e);
            this.sendHtmlResponse(response, "-1");
        }
    }

    /**
     * ժҪ��
     *
     * @return
     * @˵����ȥ�ϴ�ҳ��
     * @����������:yxy        ����ʱ�䣺2013-4-18
     * @�޸���ʷ�� [���](yxy	2013-4-18)<�޸�˵��>
     */
    @RequestMapping("/toupfile2")
    public String toUpFile2(Model model, String str1, String str2, int width, int height) {
        model.addAttribute("str1", str1);
        model.addAttribute("str2", str2);
        model.addAttribute("width", width);
        model.addAttribute("height", height);
        return "/include/upFile2";
    }

    @RequestMapping("/groupgoodsToImgCoord2")
    public String toImgCoord2(String imgsrc, Model model, String str2, String str1) {
        model.addAttribute("imgsrc", imgsrc);
        model.addAttribute("str2", str2);
        model.addAttribute("str1", str1);
        return "/main/toImgCoord2";
    }
}
