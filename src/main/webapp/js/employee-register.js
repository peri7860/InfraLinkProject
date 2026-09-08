document.addEventListener("DOMContentLoaded", function () {

    const deptCode = document.getElementById("deptCode");
    const employeeIdPreview =
        document.getElementById("employeeIdPreview");

    deptCode.addEventListener("change", function () {

        const dept = this.value;

        if (!dept) {
            employeeIdPreview.textContent =
                "部署を選択してください";
            return;
        }

        fetch(
            contextPath +
            "/pages/employeeIdPreview.do?dept_code=" +
            encodeURIComponent(dept)
        )
        .then(response => response.text())
        .then(employeeId => {

            employeeIdPreview.textContent = employeeId;

        })
        .catch(error => {

            console.error(error);

            employeeIdPreview.textContent =
                "社員番号を取得できませんでした。";

        });

    });

});