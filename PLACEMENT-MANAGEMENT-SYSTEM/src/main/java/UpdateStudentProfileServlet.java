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

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            int studentId = -1;
            String currentFullName = null;
            String currentDob = null;
            String currentStoredEmail = null;
            String currentPassword = null;
            String currentPhone = null;

            try (PreparedStatement ps = conn.prepareStatement("SELECT STUDENT_ID, fullName, dob, email, password, phone FROM STUDENT WHERE email = ?")) {
                ps.setString(1, currentEmail);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentId = rs.getInt("STUDENT_ID");
                        currentFullName = rs.getString("fullName");
                        currentDob = rs.getString("dob");
                        currentStoredEmail = rs.getString("email");
                        currentPassword = rs.getString("password");
                        currentPhone = rs.getString("phone");
                    } else {
                        response.sendRedirect("StudentProfile.jsp?error=student_not_found");
                        return;
                    }
                }
            }

            String currentCollegeName = null;
            String currentDepartment = null;
            String currentDgpa = null;

            try (PreparedStatement ps = conn.prepareStatement("SELECT collegeName, department, dgpa FROM ACCADEMIC_DETAILS WHERE STUDENT_ID = ?")) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentCollegeName = rs.getString("collegeName");
                        currentDepartment = rs.getString("department");
                        currentDgpa = String.valueOf(rs.getDouble("dgpa"));
                    }
                }
            }

            String currentLanguages = null;
            String currentSkills = null;

            try (PreparedStatement ps = conn.prepareStatement("SELECT languages, skills FROM STUDENT_SKILLS WHERE STUDENT_ID = ?")) {
                ps.setInt(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentLanguages = rs.getString("languages");
                        currentSkills = rs.getString("skills");
                    }
                }
            }

            String finalFullName = !isBlank(name) ? name : currentFullName;
            String finalEmail = !isBlank(email) ? email : currentStoredEmail;
            String finalPassword = !isBlank(password) ? password : currentPassword;
            String finalCollege = !isBlank(college) ? college : currentCollegeName;
            String finalDepartment = !isBlank(department) ? department : currentDepartment;
            String finalDgpa = !isBlank(dgpa) ? dgpa : currentDgpa;
            String finalDob = !isBlank(dob) ? dob : currentDob;
            String finalLanguages = !isBlank(languages) ? languages : currentLanguages;
            String finalSkills = !isBlank(skills) ? skills : currentSkills;
            String finalPhone = !isBlank(phone) ? phone : currentPhone;

            // Update STUDENT
            try (PreparedStatement ps = conn.prepareStatement("UPDATE STUDENT SET fullName = ?, dob = ?, email = ?, password = ?, phone = ? WHERE STUDENT_ID = ?")) {
                ps.setString(1, finalFullName);
                ps.setString(2, finalDob);
                ps.setString(3, finalEmail);
                ps.setString(4, finalPassword);
                ps.setString(5, finalPhone);
                ps.setInt(6, studentId);
                ps.executeUpdate();
            }

            // Update ACADEMIC_DETAILS
            double dgpaVal = 0.0;
            try {
                dgpaVal = Double.parseDouble(finalDgpa);
            } catch (Exception e) {
                // Ignore
            }
            try (PreparedStatement ps = conn.prepareStatement("UPDATE ACCADEMIC_DETAILS SET collegeName = ?, department = ?, dgpa = ? WHERE STUDENT_ID = ?")) {
                ps.setString(1, finalCollege != null ? finalCollege : "Unknown College");
                ps.setString(2, finalDepartment != null ? finalDepartment : "CSE");
                ps.setDouble(3, dgpaVal);
                ps.setInt(4, studentId);
                ps.executeUpdate();
            }

            // Update STUDENT_SKILLS
            // Parse finalSkills comma-separated strings to JSON array
            StringBuilder jsonSkills = new StringBuilder("[");
            if (finalSkills != null && !finalSkills.trim().isEmpty()) {
                if (finalSkills.trim().startsWith("[")) {
                    // Already JSON
                    jsonSkills.append(finalSkills.trim().substring(1, finalSkills.trim().length() - 1));
                } else {
                    String[] arr = finalSkills.split(",");
                    for (int i = 0; i < arr.length; i++) {
                        if (i > 0) jsonSkills.append(",");
                        jsonSkills.append("\"").append(arr[i].trim().replace("\"", "\\\"")).append("\"");
                    }
                }
            }
            jsonSkills.append("]");

            try (PreparedStatement ps = conn.prepareStatement("UPDATE STUDENT_SKILLS SET languages = ?, skills = ? WHERE STUDENT_ID = ?")) {
                ps.setString(1, finalLanguages != null ? finalLanguages : "English");
                ps.setString(2, jsonSkills.toString());
                ps.setInt(3, studentId);
                ps.executeUpdate();
            }

            conn.commit();

            if (session != null) {
                session.setAttribute("studentEmail", finalEmail);
                session.setAttribute("user", finalEmail);
                session.setAttribute("studentFullName", finalFullName != null ? finalFullName : "");
                if (!isBlank(finalFullName)) {
                    session.setAttribute("studentName", finalFullName.split("\\s+")[0]);
                }
            }

            response.sendRedirect("Student_dashboard.jsp?profileUpdated=true");

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
