document.addEventListener('DOMContentLoaded',function(){
    const nav = this.querySelectorAll('.nav-link');

    nav.forEach(navs => {
        navs.addEventListener('click',function(e){
            e.preventDefault();
            nav.forEach(c => c.classList.remove('active'));
            this.classList.add('active');
        })
    })
})

let likeCount = 0

document.addEventListener('DOMContentLoaded', function () {
    const likeButton = document.getElementById('like-button');
    const likeIcon = document.getElementById('like-icon');
    const likeCountSpan = document.getElementById('like-count');

    likeButton.addEventListener('click', function () {
        if (likeButton.classList.contains('active')) {
            likeButton.classList.remove('active');
            likeIcon.classList.remove('fa-solid');
            likeIcon.classList.add('fa-regular');
            likeCount--;
        } else {
            likeButton.classList.add('active');
            likeIcon.classList.remove('fa-regular');
            likeIcon.classList.add('fa-solid');
            likeCount++;
        }

        likeCountSpan.textContent = `${likeCount} like${likeCount !== 1 ? 's' : ''}`;
    });
});