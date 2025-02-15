document.addEventListener("turbo:load", function() {
  // I got the key, I got the secret…
  let key = 'mastodon-instance';
  let instance = localStorage.getItem(key) || undefined;

  // get the link from the DOM
  const button = document.querySelector('.mastodon-share');

  // refresh the link with the instance name
  const refreshlink = (instance) => {
      const sharetext = button.dataset.sharetext || document.title;
      const sharelink = button.dataset.sharelink || location.href;
      button.href = `https://${instance}/share?text=${encodeURIComponent(sharetext)}%0A${encodeURIComponent(sharelink)}`;
  }

  // got it? Let's go! 
  if (button) {
      // labels and texts from the link
      const prompt = button.dataset.prompt || 'Please tell me your Mastodon instance';
      const editlabel = button.dataset.editlabel || 'Edit your Mastodon instance';
      const edittext = button.dataset.edittext || '✏️';
      const edithtml = button.dataset.edithtml;

      // Ask the user for the instance name and set it…
      const setinstance = _ => {
          instance = window.prompt(prompt, instance);
          if (instance) {
              localStorage.setItem(key, instance);
              createeditbutton();
              refreshlink(instance);
              button.click();
          }
      }
      
      // create and insert the edit link
      const createeditbutton = _ => {
          if (document.querySelector('button.mastodon-edit')) return;
          let editlink = document.createElement('button');
            if (edithtml) {
              editlink.innerHTML = edithtml;
            } else {
              editlink.innerText = edittext;
            }
            editlink.classList.add('mastodon-edit', 'btn', 'btn-default');
            editlink.title = editlabel;
            editlink.ariaLabel = editlabel;
            editlink.addEventListener('click', (e) => {
                e.preventDefault();
                localStorage.removeItem(key);
                setinstance();
            });
            button.insertAdjacentElement('afterend', editlink);
      }
      
      // if there is a value in localstorage, create the edit link
      if (localStorage.getItem(key)) {
          createeditbutton();
      }  
      
      // When a user clicks the link
      button.addEventListener('click', (e) => {

          // If the user has already entered their instance 
          // and it is in localstorage write out the link href 
          // with the instance and the current page title and URL
          if (localStorage.getItem(key)) {
              refreshlink(localStorage.getItem(key));
              // otherwise, prompt the user for their instance and save it to localstorage
          } else {
              e.preventDefault();
              setinstance();
          }

      });
  }
});
