document.addEventListener('DOMContentLoaded',function(){
    const buttons = document.querySelectorAll('.btn-account');

    buttons.forEach(button => {
        button.addEventListener('click',function(e){
            buttons.forEach(btn => btn.classList.remove('activee'));
            this.classList.add('activee');
        })
    })
});

document.addEventListener('DOMContentLoaded',function(){
    const navs = document.querySelectorAll('.header-nav a')

    navs.forEach(a => {
        a.addEventListener('click',function(e){
            navs.forEach(navv => navv.classList.remove('active-nav'));
            this.classList.add('active-nav');
        })
    })
});