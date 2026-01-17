       // Sayfa yüklendiğinde email alanına odaklan ve enter tuşunu dinle
		window.onload = function () {
		  document.getElementById("logemail").focus();
		  document.getElementById("logpass").addEventListener("keypress", function (e) {
			if (e.key === "Enter" || e.keyCode === 13) {
			  checklogin();
			}
		  });
		};

		// Giriş kontrol fonksiyonu
		function checklogin() {
		  const email = document.getElementById("logemail");
		  const password = document.getElementById("logpass");
		  const ptxt = document.getElementById("pword-txt");
		  const etxt = document.getElementById("email-txt");
		  const Eerror = document.getElementById("email-error");
		  const perror = document.getElementById("password-error");
		  const alertBox = document.getElementById("successAlert");

		  let err = 0;

		  // Hata sıfırlama
		  Eerror.innerText = "";
		  perror.innerText = "";
		  etxt.style.color = "#919296";
		  ptxt.style.color = "#919296";
		  email.style.borderColor = "";
		  password.style.borderColor = "";

		  // Email boşsa uyarı
		  if (email.value.trim() === "") {
			email.style.borderColor = "#ec4846";
			etxt.style.color = "#ec4846";
			Eerror.innerText = " - Kullanıcı adı boş bırakılamaz!";
			err++;
		  }

		  // Şifre boşsa uyarı
		  if (password.value.trim() === "") {
			password.style.borderColor = "#ec4846";
			ptxt.style.color = "#ec4846";
			perror.innerText = " - Şifre boş bırakılamaz!";
			err++;
		  }

		  // Hata varsa işlemi durdur
		  if (err > 0) return false;

		  // Başarı mesajını göster
		  alertBox.style.display = "block";

		  // Giriş bilgilerini sunucuya gönder
		  xmlhttpPost("createLogin.ashx");

		  // 1.1 saniye sonra kutuyu geri gizle
		  setTimeout(() => {
			alertBox.style.display = "none";
		  }, 1100);

		  return false;
		}

		// AJAX ile veriyi gönder
		function xmlhttpPost(strURL) {
		  const xmlHttpReq = new XMLHttpRequest();
		  const alertBox = document.getElementById("successAlert");
		  alertBox.innerHTML = '<strong>Giriş işlemi başarıyla tamamlandı.</strong><p>Yönlendiriliyorsun lütfen bekleyiniz.</p><img src="images/loading.gif" alt="Yükleniyor..." style="margin-top:10px;">';

		  xmlHttpReq.open('POST', strURL, true);
		  xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		  xmlHttpReq.onreadystatechange = function () {
			if (xmlHttpReq.readyState === 4) {
			  updatepage(xmlHttpReq.responseText);
			}
		  };
		  xmlHttpReq.send(getquerystring());
		}

		// Form verilerini sırala
		function getquerystring() {
		  const username = document.getElementById("logemail").value;
		  const password = document.getElementById("logpass").value;
		  return 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
		}

		// Sunucu yanıtını işle
		function updatepage(response) {
		  const alertBox = document.getElementById("successAlert");

		  if (response.trim() === "ok") {
			alertBox.innerHTML = '<strong>Giriş başarılı!</strong><p>Yönlendiriliyorsun...</p><img src="images/loading.gif" alt="Yükleniyor..." style="margin-top:10px;">';
			setTimeout(() => {
			  window.location.replace("LoginGame.aspx");
			}, 600);
		  } else {
			alertBox.style.display = "none";
			alert(response); // veya özel bir hata kutusu yazılabilir
		  }
		}
