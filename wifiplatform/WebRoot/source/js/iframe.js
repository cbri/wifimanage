function reinitIframe(){ 

var iframe = document.getElementById("FRMdetail"); 

                try{ 
                var bHeight = iframe.contentWindow.document.body.scrollHeight; 
                var dHeight = iframe.contentWindow.document.documentElement.scrollHeight; 
                var height = Math.max(bHeight, dHeight);
                iframe.height = height; 
                  
                }catch (ex){
                	
                } 
               

            
    
} 
window.setInterval("reinitIframe()", 100);   //每隔100毫秒，系统自动执行一次这个reinitIframe()函数