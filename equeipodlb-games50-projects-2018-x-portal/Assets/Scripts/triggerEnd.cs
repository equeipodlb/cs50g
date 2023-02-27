using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class triggerEnd : MonoBehaviour {
    
    
    void Start() { }

    // Update is called once per frame
    void OnTriggerEnter(Collider other) {
        youWinText.show();
	}
}
