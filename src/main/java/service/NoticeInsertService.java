package service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.NoticeDAO;
import model.NoticeDTO;

public class NoticeInsertService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
        request.setCharacterEncoding("utf-8");
        HttpSession session = request.getSession();
        String employee_id = (String)session.getAttribute("employee_id");
		
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String category = request.getParameter("category");
		String visibility = request.getParameter("visibility");
		
		Part file_path = request.getPart("file_path");
		
		System.out.println("file_path = " + file_path);

		if(file_path != null) {
		    System.out.println("파일 크기 = " + file_path.getSize());
		    System.out.println("파일 이름 = " + file_path.getSubmittedFileName());
		}
		
		String fileName = null;
		if(file_path != null &&  file_path.getSize()>0) {
			String orFileName = Paths.get(file_path.getSubmittedFileName()).getFileName().toString();
			fileName = UUID.randomUUID().toString()+"_"+orFileName;
			System.out.println(fileName);
			String uploadPath = "C:\\upload2";
			
			File uploadDir = new File(uploadPath);
			if(!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			String filePath = uploadPath+File.separator+fileName;
			System.out.println("filePath :"+filePath);
			file_path.write(filePath);
			System.out.println("파일 저장 완료");
			
		}
		NoticeDTO dto = new NoticeDTO();
		dto.setEmployee_id(employee_id);
		dto.setCategory(category);
		dto.setVisibility(visibility);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setFile_path(fileName);
		
		NoticeDAO dao = new NoticeDAO();
		dao.insertNotice(dto);
		
		response.sendRedirect(request.getContextPath()+"/notice-write.do");

		
		

	}

}
