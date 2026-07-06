import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/CompanyProfileServlet")
public class CompanyProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isCompanyLoggedIn(session)) {
            response.sendRedirect("CompanyProfile.jsp?role=company");
            return;
        }

        String companyCode = (String) session.getAttribute("companyCode");
        if (companyCode == null || companyCode.isEmpty()) {
            companyCode = (String) session.getAttribute("user");
        }

        try {
        	try (Connection conn = DBUtil.getConnection()) { 
                Integer companyId = getCompanyIdByCode(conn, companyCode);
                if (companyId != null) {
                    loadProfileIntoRequest(conn, companyId, request);
                }
            }
        } catch (Exception e) {
            System.err.println("Database load failed: " + e.getMessage());
        }

        request.getRequestDispatcher("CompanyProfile.jsp").forward(request, response);
        }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isCompanyLoggedIn(session)) {
            response.sendRedirect("Login.jsp?role=company");
            return;
        }

        String companyCode = (String) session.getAttribute("companyCode");
        if (companyCode == null || companyCode.isEmpty()) {
            companyCode = (String) session.getAttribute("user");
        }

        String companyName = trim(request.getParameter("companyName"));
        String industry = trim(request.getParameter("industry"));
        String companyType = trim(request.getParameter("companyType"));
        String companyEmail = trim(request.getParameter("companyEmail"));
        String password = trim(request.getParameter("password"));

        String companyPhone = trim(request.getParameter("companyPhone"));
        String companyWebsite = trim(request.getParameter("companyWebsite"));
        String companyLinkedin = trim(request.getParameter("companyLinkedin"));

        String companyAddress = trim(request.getParameter("companyAddress"));
        String city = trim(request.getParameter("city"));
        String state = trim(request.getParameter("state"));
        String country = trim(request.getParameter("country"));
        String pincode = trim(request.getParameter("pincode"));

        String cin = trim(request.getParameter("cin"));
        String registrationNum = trim(request.getParameter("registrationNum"));
        String licenseNum = trim(request.getParameter("licenseNum"));
        String gstNum = trim(request.getParameter("gstNum"));

        if (isBlank(companyName) || isBlank(industry) || isBlank(companyType) || isBlank(companyEmail)
                || isBlank(companyPhone) || isBlank(companyWebsite) || isBlank(companyAddress)
                || isBlank(city) || isBlank(state) || isBlank(country) || isBlank(pincode)
                || isBlank(registrationNum) || isBlank(cin) || isBlank(licenseNum) || isBlank(gstNum)) {
            // Restore user inputs to request attributes
            request.setAttribute("companyName", companyName);
            request.setAttribute("industry", industry);
            request.setAttribute("companyType", companyType);
            request.setAttribute("companyEmail", companyEmail);
            request.setAttribute("companyPhone", companyPhone);
            request.setAttribute("companyWebsite", companyWebsite);
            request.setAttribute("companyLinkedin", companyLinkedin);
            request.setAttribute("companyAddress", companyAddress);
            request.setAttribute("city", city);
            request.setAttribute("state", state);
            request.setAttribute("country", country);
            request.setAttribute("pincode", pincode);
            request.setAttribute("cin", cin);
            request.setAttribute("registrationNum", registrationNum);
            request.setAttribute("licenseNum", licenseNum);
            request.setAttribute("gstNum", gstNum);
            request.setAttribute("errorMessage", "All required profile fields must be filled.");
            request.getRequestDispatcher("CompanyProfile.jsp").forward(request, response);
            return;
        }

        if (!isBlank(password) && password.length() > 10) {
            request.setAttribute("companyName", companyName);
            request.setAttribute("industry", industry);
            request.setAttribute("companyType", companyType);
            request.setAttribute("companyEmail", companyEmail);
            request.setAttribute("companyPhone", companyPhone);
            request.setAttribute("companyWebsite", companyWebsite);
            request.setAttribute("companyLinkedin", companyLinkedin);
            request.setAttribute("companyAddress", companyAddress);
            request.setAttribute("city", city);
            request.setAttribute("state", state);
            request.setAttribute("country", country);
            request.setAttribute("pincode", pincode);
            request.setAttribute("cin", cin);
            request.setAttribute("registrationNum", registrationNum);
            request.setAttribute("licenseNum", licenseNum);
            request.setAttribute("gstNum", gstNum);
            request.setAttribute("errorMessage", "Password must be at most 10 characters (per database schema).");
            request.getRequestDispatcher("CompanyProfile.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        Integer companyId = null;
        boolean dbSuccess = false;
        try {
        	conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            companyId = getCompanyIdByCode(conn, companyCode);
            if (companyId == null) {
                companyId = insertRegister(conn, companyName, companyCode, industry, companyType,
                        companyEmail, isBlank(password) ? "000000" : password);
                insertContact(conn, companyId, companyPhone, companyWebsite);
                insertAddress(conn, companyId, companyAddress, city, state, country, pincode);
                insertLegal(conn, companyId, registrationNum, cin, licenseNum);
            } else {
                updateRegister(conn, companyId, companyName, industry, companyType, companyEmail, password);
                upsertContact(conn, companyId, companyPhone, companyWebsite);
                upsertAddress(conn, companyId, companyAddress, city, state, country, pincode);
                upsertLegal(conn, companyId, registrationNum, cin, licenseNum);
            }

            conn.commit();
            dbSuccess = true;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Database operation failed (ignored per request): " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        if (companyId == null) {
            try {
            	try (Connection conn1 = DBUtil.getConnection()) {
                    companyId = getCompanyIdByCode(conn1, companyCode);
                }
            } catch (Exception e) {
                System.err.println("Failed to fetch companyId from database: " + e.getMessage());
            }
            if (companyId == null) {
                companyId = (int) (Math.random() * 10000);
            }
        }

        request.setAttribute("companyName", companyName);
        request.setAttribute("industry", industry);
        request.setAttribute("companyType", companyType);
        request.setAttribute("companyEmail", companyEmail);
        request.setAttribute("companyPhone", companyPhone);
        request.setAttribute("companyWebsite", companyWebsite);
        request.setAttribute("companyLinkedin", companyLinkedin);
        request.setAttribute("companyAddress", companyAddress);
        request.setAttribute("city", city);
        request.setAttribute("state", state);
        request.setAttribute("country", country);
        request.setAttribute("pincode", pincode);
        request.setAttribute("cin", cin);
        request.setAttribute("registrationNum", registrationNum);
        request.setAttribute("licenseNum", licenseNum);
        request.setAttribute("gstNum", gstNum);

        if (dbSuccess) {
            request.setAttribute("successMessage", "Company profile saved successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to save company profile (database offline).");
        }

        request.getRequestDispatcher("CompanyProfile.jsp").forward(request, response);
    }

    private boolean isCompanyLoggedIn(HttpSession session) {
        return session != null && "company".equals(session.getAttribute("role"));
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private Integer getCompanyIdByCode(Connection conn, String companyCode) throws SQLException {
        String sql = "SELECT COMPANY_ID FROM Register WHERE COMPANY_CODE = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("COMPANY_ID");
                }
            }
        }
        return null;
    }

    private void loadProfileIntoRequest(Connection conn, int companyId, HttpServletRequest request)
            throws SQLException {

        String registerSql = "SELECT COMPANY_NAME, COMPANY_CODE, INDUSTRY, COMPANY_TYPE, COMPANY_EMAIL "
                + "FROM Register WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(registerSql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("companyName", rs.getString("COMPANY_NAME"));
                    request.setAttribute("companyCode", rs.getString("COMPANY_CODE"));
                    request.setAttribute("industry", rs.getString("INDUSTRY"));
                    request.setAttribute("companyType", rs.getString("COMPANY_TYPE"));
                    request.setAttribute("companyEmail", rs.getString("COMPANY_EMAIL"));
                }
            }
        }

        String contactSql = "SELECT COMPANY_PHONENO, COMPANY_WEBSITE_LINK FROM COMPANY_CONTACT_DETAILS "
                + "WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(contactSql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("companyPhone", rs.getString("COMPANY_PHONENO"));
                    request.setAttribute("companyWebsite", rs.getString("COMPANY_WEBSITE_LINK"));
                }
            }
        }

        String addressSql = "SELECT COMPANY_ADDRESS, CITY, STATE, COUNTRY, PINCODE "
                + "FROM COMPANY_ADDRESS_DETAILS WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(addressSql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("companyAddress", rs.getString("COMPANY_ADDRESS"));
                    request.setAttribute("city", rs.getString("CITY"));
                    request.setAttribute("state", rs.getString("STATE"));
                    request.setAttribute("country", rs.getString("COUNTRY"));
                    request.setAttribute("pincode", rs.getString("PINCODE"));
                }
            }
        }

        String legalSql = "SELECT REGISTRATION_NUM, PAN_NUM, LICENSE_NUM FROM COMPANY_LEGAL_INFO "
                + "WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(legalSql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("registrationNum", rs.getString("REGISTRATION_NUM"));
                    request.setAttribute("cin", rs.getString("PAN_NUM"));
                    request.setAttribute("licenseNum", rs.getString("LICENSE_NUM"));
                }
            }
        }
    }



    private int insertRegister(Connection conn, String companyName, String companyCode, String industry,
            String companyType, String companyEmail, String password) throws SQLException {
        String sql = "INSERT INTO Register (COMPANY_NAME, COMPANY_CODE, INDUSTRY, COMPANY_TYPE, COMPANY_EMAIL, PASSWORD) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, companyName);
            ps.setString(2, companyCode);
            ps.setString(3, industry);
            ps.setString(4, companyType);
            ps.setString(5, companyEmail);
            ps.setString(6, password);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to obtain new COMPANY_ID");
    }

    private void updateRegister(Connection conn, int companyId, String companyName, String industry,
            String companyType, String companyEmail, String password) throws SQLException {

        String sql;
        if (isBlank(password)) {
            sql = "UPDATE Register SET COMPANY_NAME = ?, INDUSTRY = ?, COMPANY_TYPE = ?, COMPANY_EMAIL = ? "
                    + "WHERE COMPANY_ID = ?";
        } else {
            sql = "UPDATE Register SET COMPANY_NAME = ?, INDUSTRY = ?, COMPANY_TYPE = ?, COMPANY_EMAIL = ?, PASSWORD = ? "
                    + "WHERE COMPANY_ID = ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ps.setString(2, industry);
            ps.setString(3, companyType);
            ps.setString(4, companyEmail);
            if (isBlank(password)) {
                ps.setInt(5, companyId);
            } else {
                ps.setString(5, password);
                ps.setInt(6, companyId);
            }
            ps.executeUpdate();
        }
    }

    private void insertContact(Connection conn, int companyId, String phone, String website) throws SQLException {
        String sql = "INSERT INTO COMPANY_CONTACT_DETAILS (COMPANY_ID, COMPANY_PHONENO, COMPANY_WEBSITE_LINK) "
                + "VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, phone);
            ps.setString(3, website);
            ps.executeUpdate();
        }
    }

    private void upsertContact(Connection conn, int companyId, String phone, String website) throws SQLException {
        if (rowExists(conn, "COMPANY_CONTACT_DETAILS", companyId)) {
            String sql = "UPDATE COMPANY_CONTACT_DETAILS SET COMPANY_PHONENO = ?, COMPANY_WEBSITE_LINK = ? "
                    + "WHERE COMPANY_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, phone);
                ps.setString(2, website);
                ps.setInt(3, companyId);
                ps.executeUpdate();
            }
        } else {
            insertContact(conn, companyId, phone, website);
        }
    }

    private void insertAddress(Connection conn, int companyId, String address, String city,
            String state, String country, String pincode) throws SQLException {
        String sql = "INSERT INTO COMPANY_ADDRESS_DETAILS (COMPANY_ID, COMPANY_ADDRESS, CITY, STATE, COUNTRY, PINCODE) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, address);
            ps.setString(3, city);
            ps.setString(4, state);
            ps.setString(5, country);
            ps.setString(6, pincode);
            ps.executeUpdate();
        }
    }

    private void upsertAddress(Connection conn, int companyId, String address, String city,
            String state, String country, String pincode) throws SQLException {
        if (rowExists(conn, "COMPANY_ADDRESS_DETAILS", companyId)) {
            String sql = "UPDATE COMPANY_ADDRESS_DETAILS SET COMPANY_ADDRESS = ?, CITY = ?, STATE = ?, "
                    + "COUNTRY = ?, PINCODE = ? WHERE COMPANY_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, address);
                ps.setString(2, city);
                ps.setString(3, state);
                ps.setString(4, country);
                ps.setString(5, pincode);
                ps.setInt(6, companyId);
                ps.executeUpdate();
            }
        } else {
            insertAddress(conn, companyId, address, city, state, country, pincode);
        }
    }

    private void insertLegal(Connection conn, int companyId, String regNum, String pan, String license)
            throws SQLException {
        String sql = "INSERT INTO COMPANY_LEGAL_INFO (COMPANY_ID, REGISTRATION_NUM, PAN_NUM, LICENSE_NUM) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, regNum);
            ps.setString(3, pan);
            ps.setString(4, license);
            ps.executeUpdate();
        }
    }

    private void upsertLegal(Connection conn, int companyId, String regNum, String pan, String license)
            throws SQLException {
        if (rowExists(conn, "COMPANY_LEGAL_INFO", companyId)) {
            String sql = "UPDATE COMPANY_LEGAL_INFO SET REGISTRATION_NUM = ?, PAN_NUM = ?, LICENSE_NUM = ? "
                    + "WHERE COMPANY_ID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, regNum);
                ps.setString(2, pan);
                ps.setString(3, license);
                ps.setInt(4, companyId);
                ps.executeUpdate();
            }
        } else {
            insertLegal(conn, companyId, regNum, pan, license);
        }
    }

    private boolean rowExists(Connection conn, String tableName, int companyId) throws SQLException {
        String sql = "SELECT 1 FROM " + tableName + " WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
