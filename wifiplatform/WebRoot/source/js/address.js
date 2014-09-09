
    $(document).ready(function () {
        $('#cc_lick').click(function () {
           
           var cmbProvince_val = $("#cmbProvince").val();
           var cmbCity_val = $("#cmbCity").val();
           var cmbArea_val = $("#cmbArea").val();
           var province_se = "<b>省：</b>"+"<select><option>" + cmbProvince_val + "</option></select>";
           var city_se = "<b>市：</b>" + "<select><option>" + cmbCity_val + "</option></select>";
           var area_se = "<b>区：</b>" + "<select><option>" + cmbArea_val + "</option></select>" + "<span class='remove'><img src='images/shao.png'/></span>";
           
           var div = "<p class='clone' style='float:left;width:100%;cursor:pointer'>"+province_se+city_se+area_se+"</p>"
             
            $('.sheng').append(div);
            $(".remove").click(function(){
                 $(this).parent().remove();
            })
           
        })
    })
