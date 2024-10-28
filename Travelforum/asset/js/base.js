document.addEventListener('DOMContentLoaded',function(){
    const buttons = document.querySelectorAll('.btn-account');

    buttons.forEach(button => {
        button.addEventListener('click',function(e){
            e.preventDefault();
            buttons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('activee');
        })
    })
});

document.addEventListener('DOMContentLoaded',function(){
    const navs = document.querySelectorAll('.header-nav a')

    navs.forEach(a => {
        a.addEventListener('click',function(e){
            e.preventDefault();
            navs.forEach(navv => navv.classList.remove('active-nav'));
            this.classList.add('active-nav');
        })
    })
});