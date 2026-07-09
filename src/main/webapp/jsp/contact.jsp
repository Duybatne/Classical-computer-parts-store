<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layout" %>

<t:main title="Contact" activePage="contact">
  <jsp:body>

    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
      <h1 class="text-center text-white display-6 wow fadeInUp" data-wow-delay="0.1s">Contact Us</h1>
      <ol class="breadcrumb justify-content-center mb-0 wow fadeInUp" data-wow-delay="0.3s">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li class="breadcrumb-item"><a href="#">Pages</a></li>
        <li class="breadcrumb-item active text-white">Contact</li>
      </ol>
    </div>
    <!-- Single Page Header End -->

    <!-- Contact Start -->
    <div class="container-fluid contact py-5">
      <div class="container py-5">
        <div class="row g-4">
          <div class="col-lg-4 wow fadeInUp" data-wow-delay="0.1s">
            <div class="contact-item">
              <div class="contact-icon">
                <i class="fas fa-map-marker-alt"></i>
              </div>
              <div>
                <h5>Address</h5>
                <p class="mb-0">123 Street New York.USA</p>
              </div>
            </div>
          </div>
          <div class="col-lg-4 wow fadeInUp" data-wow-delay="0.3s">
            <div class="contact-item">
              <div class="contact-icon">
                <i class="fas fa-phone-alt"></i>
              </div>
              <div>
                <h5>Phone</h5>
                <p class="mb-0">(+012) 3456 7890</p>
              </div>
            </div>
          </div>
          <div class="col-lg-4 wow fadeInUp" data-wow-delay="0.5s">
            <div class="contact-item">
              <div class="contact-icon">
                <i class="fas fa-envelope"></i>
              </div>
              <div>
                <h5>Email</h5>
                <p class="mb-0">info@example.com</p>
              </div>
            </div>
          </div>
        </div>

        <div class="row g-4 mt-4">
          <div class="col-lg-7 wow fadeInUp" data-wow-delay="0.1s">
            <h2 class="mb-4">Send a Message</h2>

            <c:if test="${not empty error}">
              <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
              <div class="alert alert-success">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/contact" method="post">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <div class="row g-4">
                <div class="col-lg-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="name" name="name"
                           value="${not empty name ? name : sessionScope.user.hoTen}" placeholder="Your Name" required>
                    <label for="name">Your Name</label>
                  </div>
                </div>
                <div class="col-lg-6">
                  <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email"
                           value="${not empty email ? email : sessionScope.user.email}" placeholder="Your Email" required>
                    <label for="email">Your Email</label>
                  </div>
                </div>
                <div class="col-12">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="subject" name="subject"
                           value="${subject}" placeholder="Subject">
                    <label for="subject">Subject</label>
                  </div>
                </div>
                <div class="col-12">
                  <div class="form-floating">
                    <textarea class="form-control" placeholder="Leave a message here" id="message"
                              name="message" style="height: 160px" required>${message}</textarea>
                    <label for="message">Message</label>
                  </div>
                </div>
                <div class="col-12">
                  <button class="btn btn-primary rounded-pill py-3 px-5" type="submit">Send Message</button>
                </div>
              </div>
            </form>
          </div>
          <div class="col-lg-5 wow fadeInUp" data-wow-delay="0.3s">
            <div class="rounded h-100">
              <iframe class="rounded w-100" style="height: 400px;"
                      src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d387191.337503466!2d-73.97968099999998!3d40.69747000000002!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c24fa5d33f083b%3A0xc80b8f06e177fe62!2sNew+York%2C+NY%2C+USA!5e0!3m2!1sen!2s!4v1559466488940!5m2!1sen!2s"
                      allowfullscreen="" loading="lazy"></iframe>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Contact End -->

  </jsp:body>
</t:main>
