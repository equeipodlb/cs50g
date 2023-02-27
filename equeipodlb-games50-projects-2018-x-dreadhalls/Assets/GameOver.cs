using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOver : MonoBehaviour {
    // Use this for initialization
    public static Vector3 position;
    private GameObject audioSource;
    void Start() { audioSource = GameObject.FindGameObjectWithTag("AudioSource"); }

    // Update is called once per frame
    void Update() {
        position = Camera.main.gameObject.transform.position;
        if (position.y < -1000) {
            LevelGUI.reset();
            Destroy(audioSource);
            SceneManager.LoadScene("Endgame");
        }
    }
}