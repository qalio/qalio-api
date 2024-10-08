package adams

import "testing"

func TestInit(t *testing.T) {
	expected := "adams module initialized"
	if got := Init(); got != expected {
		t.Errorf("Init() = %q, want %q", got, expected)
	}
}
