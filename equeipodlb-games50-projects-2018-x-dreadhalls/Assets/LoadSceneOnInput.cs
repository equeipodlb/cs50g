using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {

	public static string sceneName;
	// Use this for initialization
	void Start () {}
	
	// Update is called once per frame
	void Update() {
        if (Input.GetAxis("Submit") == 1) {
            sceneName = SceneManager.GetActiveScene().name;
            if (sceneName == "Title") {
                SceneManager.LoadScene("Play");
            }
            else if (sceneName == "Endgame") {
                SceneManager.LoadScene("Title");
            }
        }
    }
}
