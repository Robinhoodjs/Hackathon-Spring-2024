import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-app.js";
  import { getFirestore, doc, getDoc, getDocs, collection,query } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-firestore.js";

// TODO: Replace the following with your app's Firebase project configuration
// See: https://support.google.com/firebase/answer/7015592
const firebaseConfig = {
    apiKey: "AIzaSyAEEmKGAqgcG4m2s3m1aQ0iWLvAaFnSswE",
    authDomain: "hackaton-b2efc.firebaseapp.com",
    projectId: "hackaton-b2efc",
    storageBucket: "hackaton-b2efc.appspot.com",
    messagingSenderId: "122334640804",
    appId: "1:122334640804:web:2e262fed2ecb7fd0534431",
    measurementId: "G-T653G20QHQ"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);


// Initialize Cloud Firestore and get a reference to the service
const db = getFirestore(app);
class Event {
    constructor(
      id,
      name,
      description,
      pictures,
      organizatorId,
      facultaty,
      time
    ) {
      this.id = id;
      this.name = name;
      this.description = description;
      this.pictures = pictures;
      this.organizatorId = organizatorId;
      this.facultaty = facultaty;
      this.time = time;
      this.listOfStringPictures = null;
    }
  
    toJSON() {
      return {
        id: this.id,
        name: this.name,
        description: this.description,
        pictures: this.pictures,
        organizator: this.organizatorId,
        facultaty: this.facultaty,
        time: this.time,
      };
    }
  
    static fromMap(map) {
      return new Event(
        map.id,
        map.title,
        map.description,
        map.imageList,
        map.idCreatedBy,
        map.facultaty,
        map.dateTime
      );
    }
  }

  let events=[

  ]

  const q = query(collection(db, "eventsPublish"));


  const querySnapshot = await getDocs(q);
  
  querySnapshot.forEach(async(el) => {
    // doc.data() is never undefined for query doc snapshots
    //console.log(doc.id, " => ", doc.data());
    events.push({
        "id":`${el.id}`,
        "title":`${el.data().title}`,
        "facultaty":`${el.data().facultaty}`,
        "description":`${el.data().description}`,
        "time":`${el.data().dateTime}`,
        "creator":`${el.data().idCreatedBy}`,
        "image":`${el.data().imageList}`
    })
  }
);


console.log(events[0].id)
//czesc pracujaca z apka

const feed = document.getElementsByClassName("feed")[0]
console.log(events.length)
//loopka dodająca posty
const filluppage = async () =>{
    for (let index = 0; index < events.length; index++) {
        let usr = doc(db,"users",`${events[index].creator}`)
        let usrsnap = await getDoc(usr);
        feed.innerHTML += `<a href="https://www.w3schools.com"><div class="post" id="${events[index].id}"><div class="posttop"><div class="user"><img class="userpng" src="${usrsnap.data().image}"><div class="userinfo"><div class="userinfo-cont"><div class="username">${usrsnap.data().username}</div><div class="cat"> w Edukacji</div></div><div class="posttime">3 minuty temu</div></div><div class="extenduserinfo"></div></div></div><img class="postpng" src="${events[index].image}"><div class="postbot"><p class="shortpostdesc">${events[index].title}</p><div class="posticons"><div class="signed"><div class="heart"></div><div class="signed-count">21 zapisanych</div></div><div class="coms"><div class="comsico"></div><div class="coms-count">4 komentarze</div></div></div></div></div></a>
        `

    }
}
filluppage()
const test = document.body