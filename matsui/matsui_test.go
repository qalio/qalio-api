package matsui

import "testing"

func TestInit(t *testing.T) {
	expected := "matsui module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
