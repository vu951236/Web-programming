document.addEventListener('DOMContentLoaded',function(){
    const nav = this.querySelectorAll('.nav-link');

    nav.forEach(navs => {
        navs.addEventListener('click',function(e){
            nav.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
        })
    })
})