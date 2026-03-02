<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

    session.removeAttribute("userId");
    session.removeAttribute("userName");
    session.removeAttribute("userRole");
    

    session.invalidate();
    

    response.sendRedirect("login.jsp?msg=logged_out");
%>
<%
    String msg = request.getParameter("msg");
    if("logged_out".equals(msg)) {
%>
    <div style="background: #e3f2fd; color: #0d47a1; padding: 10px; border-radius: 8px; margin-bottom: 15px; text-align: center;">
        ✅ You have been logged out successfully.
    </div>
<% 
    } else if("access_denied".equals(msg)) {
%>
    <div style="background: #ffebee; color: #c62828; padding: 10px; border-radius: 8px; margin-bottom: 15px; text-align: center;">
        ⚠️ Please login to access the dashboard.
    </div>
<% } %>