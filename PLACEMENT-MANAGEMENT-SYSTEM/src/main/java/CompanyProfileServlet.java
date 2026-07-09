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
            response.sendRedirect("Login.jsp?role=company");
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
                request.setAttribute("errorMessage", "Company account not found in the database.");
                request.getRequestDispatcher("CompanyProfile.jsp").forward(request, response);
                return;
            }

            updateRegister(conn, companyId, companyName, industry, companyType, password);
            updateContact(conn, companyId, companyPhone, companyEmail, companyWebsite, companyLinkedin);
            updateAddress(conn, companyId, companyAddress, city, state, country, pincode);
            updateLegal(conn, companyId, registrationNum, cin, licenseNum, gstNum);

            conn.commit();
            dbSuccess = true;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Database operation failed: " + e.getMessage());
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
        String sql = "SELECT COMPANY_ID FROM BASIC_DETAILS WHERE companyCode = ?";
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

        String sql = "SELECT b.companyName, b.companyCode, b.industry, b.companyType, "
                + "c.companyPhone, c.companyEmail, c.companyWebsite, c.companyLinkedin, "
                + "a.companyAddress, a.city, a.state, a.country, a.pincode, "
                + "l.registrationNum, l.cin, l.licenseNum, l.gstNum "
                + "FROM BASIC_DETAILS b "
                + "LEFT JOIN COMPANY_CONTACT_DETAILS c ON b.COMPANY_ID = c.COMPANY_ID "
                + "LEFT JOIN COMPANY_ADDRESS_DETAILS a ON b.COMPANY_ID = a.COMPANY_ID "
                + "LEFT JOIN COMPANY_LEGAL_INFO l ON b.COMPANY_ID = l.COMPANY_ID "
                + "WHERE b.COMPANY_ID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("companyName", rs.getString("companyName"));
                    request.setAttribute("companyCode", rs.getString("companyCode"));
                    request.setAttribute("industry", rs.getString("industry"));
                    request.setAttribute("companyType", rs.getString("companyType"));

                    request.setAttribute("companyPhone", rs.getString("companyPhone"));
                    request.setAttribute("companyEmail", rs.getString("companyEmail"));
                    request.setAttribute("companyWebsite", rs.getString("companyWebsite"));
                    request.setAttribute("companyLinkedin", rs.getString("companyLinkedin"));

                    request.setAttribute("companyAddress", rs.getString("companyAddress"));
                    request.setAttribute("city", rs.getString("city"));
                    request.setAttribute("state", rs.getString("state"));
                    request.setAttribute("country", rs.getString("country"));
                    request.setAttribute("pincode", rs.getString("pincode"));

                    request.setAttribute("registrationNum", rs.getString("registrationNum"));
                    request.setAttribute("cin", rs.getString("cin"));
                    request.setAttribute("licenseNum", rs.getString("licenseNum"));
                    request.setAttribute("gstNum", rs.getString("gstNum"));
                }
            }
        }
    }

    private void updateRegister(Connection conn, int companyId, String companyName, String industry,
            String companyType, String password) throws SQLException {

        String sql;
        if (isBlank(password)) {
            sql = "UPDATE BASIC_DETAILS SET companyName = ?, industry = ?, companyType = ? "
                    + "WHERE COMPANY_ID = ?";
        } else {
            sql = "UPDATE BASIC_DETAILS SET companyName = ?, industry = ?, companyType = ?, password = ? "
                    + "WHERE COMPANY_ID = ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ps.setString(2, industry);
            ps.setString(3, companyType);
            if (isBlank(password)) {
                ps.setInt(4, companyId);
            } else {
                ps.setString(4, password);
                ps.setInt(5, companyId);
            }
            ps.executeUpdate();
        }
    }

    private void updateContact(Connection conn, int companyId, String phone, String email, String website, String linkedin) throws SQLException {
        String sql = "UPDATE COMPANY_CONTACT_DETAILS SET companyPhone = ?, companyEmail = ?, companyWebsite = ?, companyLinkedin = ? "
                + "WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, email);
            ps.setString(3, website);
            ps.setString(4, linkedin);
            ps.setInt(5, companyId);
            ps.executeUpdate();
        }
    }

    private void updateAddress(Connection conn, int companyId, String address, String city,
            String state, String country, String pincode) throws SQLException {
        String sql = "UPDATE COMPANY_ADDRESS_DETAILS SET companyAddress = ?, city = ?, state = ?, "
                + "country = ?, pincode = ? WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address);
            ps.setString(2, city);
            ps.setString(3, state);
            ps.setString(4, country);
            ps.setString(5, pincode);
            ps.setInt(6, companyId);
            ps.executeUpdate();
        }
    }

    private void updateLegal(Connection conn, int companyId, String regNum, String cin, String license, String gst)
            throws SQLException {
        String sql = "UPDATE COMPANY_LEGAL_INFO SET registrationNum = ?, cin = ?, licenseNum = ?, gstNum = ? "
                + "WHERE COMPANY_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, regNum);
            ps.setString(2, cin);
            ps.setString(3, license);
            ps.setString(4, gst);
            ps.setInt(5, companyId);
            ps.executeUpdate();
        }
    }
}
