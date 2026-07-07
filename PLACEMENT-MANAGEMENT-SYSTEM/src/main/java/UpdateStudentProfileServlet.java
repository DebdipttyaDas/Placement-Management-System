import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateStudentProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 500 * 1024,
        maxRequestSize = 1024 * 1024
)
public class UpdateStudentProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String currentEmail = session != null ? (String) session.getAttribute("studentEmail") : null;
        if (isBlank(currentEmail)) {
            currentEmail = request.getParameter("email");
        }

        if (isBlank(currentEmail)) {
            response.sendRedirect("StudentProfile.jsp?error=missing_session");
            return;
        }

        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String password = trim(request.getParameter("password"));
        String phone = trim(request.getParameter("phone"));
        String dob = trim(request.getParameter("dob"));
        String college = trim(request.getParameter("college"));
        String department = trim(request.getParameter("department"));
        String dgpa = trim(request.getParameter("dgpa"));
        String languages = trim(request.getParameter("languages"));
        String skills = trim(request.getParameter("skills"));

        Part photoPart = request.getPart("photo");
        String photoPath = null;

        if (photoPart != null && photoPart.getSize() > 0) {
            String fileName = sanitizeFileName(photoPart.getSubmittedFileName());
            if (!isBlank(fileName) && isValidImage(fileName)) {
                String uniqueName = "student_" + UUID.randomUUID() + "_" + fileName;
                String uploadDirPath = getServletContext().getRealPath("/uploads");
                if (uploadDirPath == null) {
                    uploadDirPath = Paths.get(System.getProperty("user.dir"), "uploads").toString();
                }
                Path uploadDir = Paths.get(uploadDirPath);
                Files.createDirectories(uploadDir);
                Path targetPath = uploadDir.resolve(uniqueName);
                photoPart.write(targetPath.toString());
                photoPath = "uploads/" + uniqueName;
            } else {
                response.sendRedirect("StudentProfile.jsp?error=invalid_photo");
                return;
            }
        }

        try {
        	try (Connection conn = DBUtil.getConnection()) {
                boolean hasPhoneColumn = hasColumn(conn, "students", "phone");

                String selectQuery = "SELECT full_name, college_name, department, cgpa, dob, email, password, languages, skills, photo_path";
                if (hasPhoneColumn) {
                    selectQuery += ", phone";
                }
                selectQuery += " FROM students WHERE email = ?";

                String currentFullName = null;
                String currentCollegeName = null;
                String currentDepartment = null;
                String currentCgpa = null;
                String currentDob = null;
                String currentStoredEmail = null;
                String currentPassword = null;
                String currentLanguages = null;
                String currentSkills = null;
                String currentPhotoPath = null;
                String currentPhone = null;

                try (PreparedStatement selectStmt = conn.prepareStatement(selectQuery)) {
                    selectStmt.setString(1, currentEmail);
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            currentFullName = rs.getString("full_name");
                            currentCollegeName = rs.getString("college_name");
                            currentDepartment = rs.getString("department");
                            currentCgpa = rs.getString("cgpa");
                            currentDob = rs.getString("dob");
                            currentStoredEmail = rs.getString("email");
                            currentPassword = rs.getString("password");
                            currentLanguages = rs.getString("languages");
                            currentSkills = rs.getString("skills");
                            currentPhotoPath = rs.getString("photo_path");
                            if (hasPhoneColumn) {
                                currentPhone = rs.getString("phone");
                            }
                        } else {
                            response.sendRedirect("StudentProfile.jsp?error=student_not_found");
                            return;
                        }
                    }
                }

                String finalFullName = !isBlank(name) ? name : currentFullName;
                String finalEmail = !isBlank(email) ? email : currentStoredEmail;
                String finalPassword = !isBlank(password) ? password : currentPassword;
                String finalCollege = !isBlank(college) ? college : currentCollegeName;
                String finalDepartment = !isBlank(department) ? department : currentDepartment;
                String finalCgpa = !isBlank(dgpa) ? dgpa : currentCgpa;
                String finalDob = !isBlank(dob) ? dob : currentDob;
                String finalLanguages = !isBlank(languages) ? languages : currentLanguages;
                String finalSkills = !isBlank(skills) ? skills : currentSkills;
                String finalPhotoPath = !isBlank(photoPath) ? photoPath : currentPhotoPath;
                String finalPhone = !isBlank(phone) ? phone : currentPhone;

                StringBuilder updateQuery = new StringBuilder();
                updateQuery.append("UPDATE students SET ")
                           .append("full_name = ?, ")
                           .append("college_name = ?, ")
                           .append("department = ?, ")
                           .append("cgpa = ?, ")
                           .append("dob = ?, ")
                           .append("email = ?, ")
                           .append("password = ?, ")
                           .append("languages = ?, ")
                           .append("skills = ?, ")
                           .append("photo_path = ?");

                if (hasPhoneColumn) {
                    updateQuery.append(", phone = ?");
                }

                updateQuery.append(" WHERE email = ?");

                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery.toString())) {
                    int index = 1;
                    updateStmt.setString(index++, finalFullName);
                    updateStmt.setString(index++, finalCollege);
                    updateStmt.setString(index++, finalDepartment);
                    updateStmt.setString(index++, finalCgpa);
                    updateStmt.setString(index++, finalDob);
                    updateStmt.setString(index++, finalEmail);
                    updateStmt.setString(index++, finalPassword);
                    updateStmt.setString(index++, finalLanguages);
                    updateStmt.setString(index++, finalSkills);
                    updateStmt.setString(index++, finalPhotoPath);
                    if (hasPhoneColumn) {
                        updateStmt.setString(index++, finalPhone);
                    }
                    updateStmt.setString(index, currentEmail);

                    int rowsUpdated = updateStmt.executeUpdate();
                    if (rowsUpdated <= 0) {
                        response.sendRedirect("StudentProfile.jsp?error=update_failed");
                        return;
                    }
                }

                if (session != null) {
                    session.setAttribute("studentEmail", finalEmail);
                    session.setAttribute("user", finalEmail);
                    session.setAttribute("studentFullName", finalFullName != null ? finalFullName : "");
                    if (!isBlank(finalFullName)) {
                        session.setAttribute("studentName", finalFullName.split("\\s+")[0]);
                    }
                }

                response.sendRedirect("Student_dashboard.jsp?profileUpdated=true");
            }
        } catch (Exception e) {
            throw new ServletException("Unable to update student profile", e);
        }
    }

    private boolean hasColumn(Connection conn, String tableName, String columnName) throws SQLException {
        DatabaseMetaData metaData = conn.getMetaData();
        try (ResultSet rs = metaData.getColumns(null, null, tableName, columnName)) {
            return rs.next();
        }
    }

    private boolean isValidImage(String fileName) {
        String lower = fileName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg");
    }

    private String sanitizeFileName(String fileName) {
        if (isBlank(fileName)) {
            return "";
        }
        String cleaned = Paths.get(fileName).getFileName().toString();
        cleaned = cleaned.replaceAll("[^a-zA-Z0-9._-]", "_");
        return cleaned;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
