package sponder

import "testing"

func TestInit(t *testing.T) {
	expected := "sponder module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
